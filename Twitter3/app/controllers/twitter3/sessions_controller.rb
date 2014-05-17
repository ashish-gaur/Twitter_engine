require_dependency "twitter3/application_controller"

module Twitter3
  class SessionsController < Twitter3::ApplicationController

    before_filter :authenticate_user, :only => [:search_user,:network, :accept, :deny, :unfollow,:follow ,:update, :home, :profile, :add_tweet, :following, :follower, :profile, :edit, :cancel, :index]
    before_filter :save_login_state, :only => [:login, :login_attempt]

    ######################Session Actions###############################

    def token_key_expired(user)
      time_left = Time.diff user.created_at, Time.now
      if (time_left[:year] > 0 || time_left[:day] > 0 || time_left[:hour] > 0 || time_left[:minute] > 3 || time_left[:second] > 60)
        true
      else
        false
      end
    end

    def confirm_user
      token = params[:token]
      @user = User.find_by_token token
      unless @user.blank?
        if token_key_expired @user
          if @user.destroy
            redirect_to activation_error_path(:error => 't_exp')
          end
        else
         unless @user.blank?
            if @user.update_attribute 'confirmed', true
              redirect_to login_path(username_or_email: @user.username, login_password: @user.encrypted_password)
            end
          else

          end
        end
      else
        redirect_to activation_error_path(:error => 't_inv')
      end
    end

    def confirm
      @title = 'Confirm'
    end

    def error
      @title = 'Error'
      case params[:error]
        when 't_exp'
          @error = 'The token has expired'
        when 'act_n_act'
          @error = 'The account has not been activated'
        when 'act_now'
          @error = 'An activation link has been sent to your mail ID'
        when  't_inv'
          @error = 'The token is invalid'
        when 'acc_succ'
        @error = 'Request accepted successfully'
        when 'den_succ'
          @error = 'Request denied successfully'
        when 'dup_req'
          @error = 'This request has been used previously'
        else
          @error = ''
      end
    end

    def login
    #Login Form
      @title = 'login'
    end

    def login_attempt
      authorized_user = User.authenticate params[:username_or_email], params[:login_password]
      if authorized_user
        if authorized_user.confirmed
          session[:user_id] = authorized_user.id
          session[:expires_in] = 5.minutes.from_now
          redirect_to(:action => 'home')
        elsif !authorized_user.confirmed
          redirect_to activation_error_path(:error => 'act_n_act')
        end
      else
        @message = 'Username or password is incorrect'
        @title = 'Signup'
        render 'login'
      end
    end

    def logout
      session[:user_id] = nil
      redirect_to :action => 'login'
    end

    def profile
      @profile = User.find_by_id (params[:id])
      @show = following? params[:id]
    end

    def user
      if @profile.pluck(:user_id) == @current_user.pluck(:user_id)
        return true
      else
        return false
      end
    end

    def edit

    end

    def update
      if @current_user.update_attributes :username => params[:user][:username],:email=> params[:user][:email], :password => params[:user][:password]
        render 'edit'
      else
        render 'edit'
      end

    end

    ######################Tweet Actions###############################

    def home
      @tweet = Tweet.find_all_by_user_id(@current_user.id)
      @tweet = @tweet.sort_by {|t| t[:created_at]}
      @tweet = @tweet.reverse

      @followed_users = @current_user.followed_users.where("twitter3_relationships.accept = true")
      unless @followed_users.nil? or @followed_users.empty?
        @followed_tweets = Tweet.find_all_by_user_id @followed_users
        @followed_tweets.each do |f|
          @tweet.append f
        end
      end

      @time = get_time @tweet

      @paginated_tweet = @tweet.paginate(:page => params[:page],:per_page => 5)
    end

    def get_time(tweets)
      time_arr = []
      tweets.each do |tweet|
        time = tweet.created_at.in_time_zone('New Delhi')
       
        time_arr.append(convert_time_to_string(time))
      end
      time_arr
    end

    def add_tweet
      @add_tweet = Tweet.new()
      @add_tweet.tweet = params[:tweet]
      @add_tweet.user_id = @current_user.id

      if @add_tweet.save
        redirect_to :use_route => 'home'
      else
        home
        render 'home'
      end
    end

    ######################Network Actions###############################

    def index
      if params[:term]
        @users = User.search params[:term], @current_user
      end

      respond_to do |format|
        format.html
        format.json { render :json => @users.to_json}
      end
    end

    def network
      follower
      following
      requests
      notifications
    end

    def requests
      @requests = @current_user.followed_users.where("twitter3_relationships.accept = false and confirmed = true")
      @paginated_requests = @requests.paginate( :page => params[:page], :per_page => 5)
    end

    def notifications
      @notifications = @current_user.followers.where("twitter3_relationships.accept = false and confirmed = true")
      @paginated_notifications = @notifications.paginate(:page => params[:page],:per_page => 5)
    end

    def follower
      @follower = @current_user.followers.where "twitter3_relationships.accept = true and confirmed = true"
      @paginated_follower = @follower.paginate(:page => params[:page],:per_page => 5)
    end

    def following
      @following = @current_user.followed_users.where("twitter3_relationships.accept = true and confirmed = true")
      @paginated_following = @following.paginate( :page => params[:page], :per_page => 5)
    end

    def following?(other_user_id)
      if @current_user.id == other_user_id
        return ''
      elsif !Relationship.exists? followed_id: other_user_id, follower_id: @current_user.id
        return 'request'
      elsif Relationship.exists? followed_id: other_user_id, follower_id: @current_user.id, accept:false
        return 'cancel'
      else
        return 'unfollow'
      end
    end

    def notify_user(request, action)
      @follower = User.find_by_id request.follower_id
      @following = User.find_by_id request.followed_id
      RelationshipMailer.notify(@follower, @following, action).deliver
    end

    def accept_request
      unless params[:token].blank?
        @request = Relationship.find_by_token params[:token]
        unless @request.blank? or @request.accept
          if @request.update_attribute 'accept', true
            notify_user(@request, 'accepted')
            redirect_to error_path :error => 'acc_succ'
          end
        else
          redirect_to error_path :error => 'dup_req'
        end
      else
      end
    end

    def accept
      unless params[:id].blank?
        @request = Relationship.find_by_follower_id_and_followed_id params[:id], @current_user.id
        unless @request.blank? or !@request.update_attribute 'accept', true
          notify_user @request, 'denied'
          redirect_to network_path
        else

        end
      else
        redirect_to error_path
      end
    end

    def deny_request
      unless params[:token].blank?
        @request = Relationship.find_by_token params[:token]
        unless @request.blank?
          if @request.destroy
            notify_user(@request, 'denied')
            redirect_to error_path :error => 'den_succ'
          end

        else
          redirect_to error_path :error => 'dup_req'
        end
      else
      end
    end

    def deny
      unless params[:id].blank?
        @request = Relationship.find_by_follower_id_and_followed_id params[:id], @current_user.id
        unless @request.blank? or !@request.destroy
          notify_user @request, 'denied'
          redirect_to network_path
        end
      else
        redirect_to error_path
      end
    end

    def cancel
      unless params[:id].blank?
        @request = Relationship.find_by_followed_id_and_follower_id(params[:id], @current_user.id)
        unless @request.blank? or !@request.destroy
          redirect_to network_path
        else
          redirect_to error_path
        end
      end
    end

    def follow
      unless params[:id].nil?
        @new_relationship = Relationship.new
        @new_relationship.follower_id = @current_user.id
        @new_relationship.followed_id = params[:id]
        @new_relationship.accept = false
        @new_relationship.token = Digest::SHA1.hexdigest [rand, Time.now, @new_relationship.follower_id, @new_relationship.followed_id].join

        unless Relationship.find_by_follower_id_and_followed_id @new_relationship.follower_id, @new_relationship.followed_id
          if @new_relationship.save
            @following =  User.find_by_id(@new_relationship.followed_id)
            RelationshipMailer.requests(@current_user, @following, @new_relationship.token).deliver
            unless params[:came_from].blank? or params[:came_from] == 'network'
              redirect_to :use_route => 'profile', :id => params[:id]
            else
              redirect_to network_path
            end
          else

          end
        else
          @following =  User.find_by_id(@new_relationship.followed_id)
          RelationshipMailer.requests(@current_user, @following, @new_relationship.token).deliver
          redirect_to network_path
        end
      end
    end

    def unfollow
      unless params[:id].nil?
        @sql = Relationship.where("follower_id = ? and followed_id = ?", @current_user.id, params[:id])
        @to_be_deleted = Relationship.find_by_sql @sql

        if Relationship.destroy @to_be_deleted[0].id
          unless params[:came_from].blank? or params[:came_from] == 'network'
            redirect_to :use_route => 'profile', :id => params[:id]
          else
            redirect_to network_path
          end
        end
      end
    end
    
    private

    def convert_time_to_string(time)
      time = time.to_s
      time_arr = Time.diff time, Time.now
      unless time_arr.blank?
        unless time_arr[:day].to_i != 0
          unless time_arr[:hour].to_i != 0
            unless time_arr[:minute].to_i != 0
              unless time_arr[:second].to_i > 0
                'just now'
              else
                time_arr[:second].to_s + (time_arr[:second] == 1 ? 'second' : 'seconds')
              end
            else
              time_arr[:minute].to_s + (time_arr[:minute] == 1 ? 'minute' : 'minutes')
            end
          else
            time_arr[:hour].to_s + (time_arr[:hour] == 1 ? 'hour' : 'hours')
          end
        else
          time.to_s[0..-6]
        end
      end
    end
  end
end
