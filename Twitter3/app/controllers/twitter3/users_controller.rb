require_dependency "twitter3/application_controller"

module Twitter3
  class UsersController < Twitter3::ApplicationController
  	before_filter :save_login_state, :only => [:new, :create]

	def new
		@user = User.new
		@title = 'Signup'
	end

	def create
		@user = User.new(params[:user])
		@user.token =  Digest::SHA1.hexdigest [Time.now, rand, @user.id].join
		@user.confirmed = false
		if @user.save
		  @user = User.find_by_id @user.id
		  UserMailer.registration_confirmation(@user).deliver
		  unless @user.confirmed
		    redirect_to activation_error_path(:error => 'act_now')
		  else
		    redirect_to login_path(username_or_email: params[:user][:username], login_password: params[:user][:password])
		  end
		else
		  @title = 'Signup'
		  render 'new'
 		end
	end
  end
end
