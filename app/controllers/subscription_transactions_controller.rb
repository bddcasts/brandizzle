class SubscriptionTransactionsController < ApplicationController
  before_filter :require_user
  before_filter :require_account_holder
  layout "print"
  
  def show
    @subscription_transaction = current_account.subscription_transactions.find(params[:id])
  end
end