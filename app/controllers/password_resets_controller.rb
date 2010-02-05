class PasswordResetsController < ApplicationController
  before_filter :find_user_by_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
    render
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "We have sent password reset instructions to #{@user.email}. Please check your email."
      redirect_to root_path
    else
      flash[:error] = "We could not find a user with email #{params[:email]}."
      render :new
    end
  end
  
  def edit
    render
  end
  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    
    if @user.save
      flash[:notice] = "Password successfully updated!"
      redirect_to brands_path
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
       "reset password process."
       redirect_to root_path
     end
   end 
end