class ApplicationController < ActionController::Base
    helper_method :current_user
  
    private
  
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  
    def require_signin
      unless current_user
        redirect_to new_session_url, alert: "Please sign in first!"
      end
    end
  end