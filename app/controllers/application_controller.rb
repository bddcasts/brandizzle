# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  
  before_filter :require_valid_subscription

  private
    def require_valid_subscription
      if current_account
        unless current_account.valid_subscription?
          forget_stored_location
          
          if current_user.account_holder?
            flash[:notice] = "You must be subscribed in order to keep using our services!"
            redirect_to account_path
          else
            flash[:notice] = "The subscription for this account has expired. Please inform your account holder."
            current_user_session.destroy
            redirect_to new_user_session_url
          end
        end
      end
    end
    
    def current_user_session
      @current_user_session ||= UserSession.find
    end

    def current_user
      @current_user ||= current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to root_path
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end
    
    def forget_stored_location
      session.delete(:return_to)
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def current_team
      current_user && current_user.team
    end
    
    def current_account
      current_team && current_team.account
    end
    
    def require_account_holder
      unless current_user.account_holder?
        flash[:notice] = "Access denied! Only the account holder can modify settings."
        redirect_to team_path
      end
    end
    
    def log
      @log ||= LogService.new
    end
    
    def check_search_terms_limit
      if current_account.search_terms_left == 0
        flash[:notice] = "You reached the limit of search terms. Query term not added."
        redirect_to account_path
      end
    end

    def check_team_members_limit
      if current_account.team_members_left == 0
        flash[:notice] = "You reached the limit of team member. User registration failed."
        redirect_to account_path
      end
    end
end
