class UserSignupsController < ApplicationController
  before_filter :find_user_by_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  skip_before_filter :require_valid_subscription

  layout "login"

  def edit
    render
  end
  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.active = true
    
    if @user.save
      flash[:notice] = "Your account has been activated!"
      redirect_to root_path
    else
      render :edit
    end
  end
  
  private
   def find_user_by_perishable_token
     @user = User.find_using_perishable_token(params[:id])
     unless @user
       flash[:notice] = "We're sorry, but we could not locate your account. " +  
       "If you are having issues try copying and pasting the URL " +  
       "from your email into your browser or restarting the " +  
       "setup password process."
       redirect_to new_user_session_path
     end
   end
end