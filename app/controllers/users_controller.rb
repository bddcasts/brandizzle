class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:edit, :update]
  
  def new
    # @user = User.new #without invitations
    @user = User.new(:invitation_token => params[:invitation_token]) #with invitations
    @user.email = @user.invitation.recipient_email if @user.invitation #with invitations
  end
  
  def create
    @user = User.new(params[:user])
    # if @user.save_without_session_maintenance #without invitations
      # @user.deliver_activation_instructions! #without invitations
    if @user.save
      # flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!" #without invitations
      # redirect_to new_user_session_path #without invitations
      UserSession.create(@user) #with invitations
      
      flash[:notice] = "Your account has been created." #with invitations
      redirect_to brand_results_path #with invitations
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