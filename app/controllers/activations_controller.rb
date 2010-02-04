class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  
  def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
    
    @user.activate!
    @user.deliver_activation_confirmation!
  
    UserSession.create(@user)
  
    flash[:notice] = "Welcome #{@user}! Your account has been activated!"
    redirect_to root_path
  end
end