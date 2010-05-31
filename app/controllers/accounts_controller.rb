class AccountsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]
  
  layout :detect_layout
  
  def new
    @account = Account.new
    @user = @account.build_holder
  end
  
  def create
    @account = Account.new((params[:account] || {}).merge(:plan_id => Plan.standard.id))
    @team = @account.build_team
    @account.holder.team = @team
    
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
  end
  
  def update
    @account = current_user.account
    if @account.update_attributes(params[:account])
      flash[:notice] = "Account information updated!"
      redirect_to account_path
    else
      flash.now[:error] = "Updating information failed!"
      render :edit
    end
  end
  
  def show
    @account = current_user.account
    redirect_to edit_account_path unless @account.card_token
  end
  
  private
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