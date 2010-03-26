class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user,    :only => [:edit, :update]
  before_filter :require_invitation, :only => [:new]
  
  layout :detect_layout
  
  def new
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save      
      flash[:notice] = "Your account has been created."
      redirect_to brand_results_path
    else
      flash.now[:error] = "Acount registration failed!"
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
  
  private
    def require_invitation
      @invitation = Invitation.find_by_token(params[:invitation_token])
      unless @invitation
        flash[:notice] = "We're sorry, but we could not locate your invitation. " +  
        "If you are having issues try copying and pasting the URL from your email into your browser."
        redirect_to new_user_session_path
      end
    end
    
    def detect_layout
      action_name == "new" && "login" || "application"
    end
end