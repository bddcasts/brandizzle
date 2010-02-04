class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = "Thank you for registering #{current_user}, your account has been created!"
      redirect_to root_path
    else
      flash[:error] = "Acount registration failed!"
      render :new
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    @user.attributes = params[:user]
    if @user.save
      flash[:notice] = "Account information updated!"
      redirect_to edit_account_path
    else
      render :edit
    end
  end
end