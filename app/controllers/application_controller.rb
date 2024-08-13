class ApplicationController < ActionController::Base
    helper_method :current_user
  
    private
  
    def current_user
      if session[:user_id]
        @current_user ||= User.find_by(id: session[:user_id])
        session[:user_id] = nil unless @current_user # Reset session if user is not found
      end
      @current_user
    end
  
    def require_signin
      unless current_user
        redirect_to new_session_url, alert: "Please sign in first!"
      end
    end
  end