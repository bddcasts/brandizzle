class UsersController < ApplicationController
  before_filter :require_user, :current_team
  before_filter :require_account_holder, :except => [:edit, :update]
  before_filter :check_team_members_limit, :only => [:create]
  
  def new
    @user = current_team.members.build
  end
  
  def create
    @user = current_team.members.build(params[:user])
    if @user.save_without_session_maintenance
      @user.deliver_user_invitation!
      flash[:notice] = "The user has been created."
      redirect_to team_path
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
    @user.attributes = params[:user]
    
    @user.save do |result|
      if result
        flash[:notice] = "Account information updated!"
        redirect_to edit_user_info_path
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