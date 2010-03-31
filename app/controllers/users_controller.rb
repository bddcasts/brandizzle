class UsersController < ApplicationController
  before_filter :require_user  
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "The user has been created."
      redirect_to brand_results_path
    else
      flash.now[:error] = "User registration failed!"
      render :new
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account information updated!"
      redirect_to edit_user_path(current_user)
    else
      render :edit
    end
  end
end