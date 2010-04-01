class UsersController < ApplicationController
  before_filter :require_user, :current_team
  
  def new
    @user = current_team.members.build
  end
  
  def create
    @user = current_team.members.build(params[:user])
    if @user.save
      flash[:notice] = "The user has been created."
      redirect_to team_path
    else
      flash.now[:error] = "User registration failed!"
      render :new
    end
  end
  
  def edit
    @user = current_team.members.find(params[:id])
  end
  
  def update
    @user = current_team.members.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account information updated!"
      redirect_to team_path
    else
      render :edit
    end
  end
  
  def destroy
    @user = current_team.members.find(params[:id])
    @user.destroy
    flash[:success] = "Successfully removed!"
    redirect_to team_path
  end
  
  def alter_status
    @user = current_team.members.find(params[:id])
    @user.toggle_active
    flash[:success] = @user.active? ? "User enabled!" : "User disabled!"
    redirect_to team_path
  end
end