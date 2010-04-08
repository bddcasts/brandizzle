class UsersController < ApplicationController
  before_filter :require_user, :current_team
  
  def new
    @user = current_team.members.build
  end
  
  def create
    @user = current_team.members.build(params[:user])
    if @user.save
      @user.deliver_user_invitation!
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
    @user.attributes = params[:user]
    
    @user.save do |result|
      if result
        flash[:notice] = "Account information updated!"
        redirect_to edit_user_path(@user)
      else 
        render :edit
      end
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