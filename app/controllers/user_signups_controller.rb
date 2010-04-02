class UserSignupsController < ApplicationController
  before_filter :find_user_by_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user

  def edit
    render
  end
  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    
    if @user.save
      flash[:notice] = "Your account has been created!"
      redirect_to edit_user_path(@user)
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