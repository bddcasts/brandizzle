class AccountsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]
  before_filter :require_invitation, :only => [:new]
  
  layout :detect_layout
  
  def new
    @account = Account.new(:invitation => @invitation)
    @user = @account.build_holder
    @user.email = @account.invitation.recipient_email if @invitation
  end
  
  def create
    @account = Account.new(params[:account])
    @team = @account.build_team
    @account.holder.team = @team
    @account.build_subscription(:plan_id => Plan.standard.id)
    
    if @account.save
      flash[:notice] = "Your account has been created."
      redirect_to brand_results_path
    else
      flash.now[:error] = "Acount registration failed!"
      render :new
    end
  end
  
  def edit
    @account = current_user.account
    @subscription = @account.subscription
  end
  
  def update
    @account = current_user.account
    if @account.update_attributes(params[:account])
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
      case action_name
      when "new"
        "login"
      when "create"
        "login"
      else
        "application"
      end
    end
end