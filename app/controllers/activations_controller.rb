class ActivationsController < ApplicationController
  before_filter :require_no_user
  skip_before_filter :require_valid_subscription
  
  layout "login"

  def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.week)
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "activation process."
      redirect_to new_user_session_path
    end
  end

  def create
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    @user.active = true
    
    if @user.save
      flash[:notice] = "Welcome #{@user}!"
      redirect_to root_path
    else
      flash[:error] = "We're sorry, but an error ocurred!"
      render :action => :new
    end
  end
  
  protected
    def ssl_required?
      true
    end
end
