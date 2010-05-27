class SubscriptionsController < ApplicationController
  before_filter :require_user
  
  def update
    @subscription = current_user.account.subscription
    if @subscription.update_attributes(params[:subscription])
      flash[:notice] = "Account information updated!"
      redirect_to edit_account_path
    else
      render :controller => "account", :action => "edit"
    end
  end
end