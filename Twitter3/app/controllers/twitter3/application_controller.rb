module Twitter3
  class ApplicationController < ::ApplicationController
  	protect_from_forgery

	protected
	def authenticate_user
	get_session_time_left
	unless @session_time_left > 0
	  session[:user_id] = nil
	  redirect_to :action => 'login'
	else
	  update_activity_time
	  unless session[:user_id]
	    redirect_to :controller => 'sessions', :action => 'login'
	    return false
	  else
	    @current_user = User.find session[:user_id]
	    return true
	  end
	end

	end

	def save_login_state
	if session[:user_id]
	  update_activity_time
	  redirect_to :controller => 'sessions', :action => 'home'
	  return false
	else
	  return true
	end
	end

	def update_activity_time
	session[:expires_in] = 5.minutes.from_now
	end

	def get_session_time_left
	expire_time = session[:expires_in] || Time.now
	@session_time_left = (expire_time - Time.now).to_i
	end

  end
end
