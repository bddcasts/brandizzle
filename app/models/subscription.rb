# == Schema Information
#
# Table name: subscriptions
#
#  id              :integer(4)      not null, primary key
#  plan_id         :string(255)
#  account_id      :integer(4)      indexed
#  subscription_id :integer(4)
#  card_token      :string(255)
#  customer_id     :string(255)
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class Subscription < ActiveRecord::Base
  belongs_to :account
  
  validate :valid_card
  
  before_save :save_subscription_to_braintree
  
  attr_accessor :card_number, :expiration_date, :cvv
  
  private
    def valid_card
      true
    end
  
    def save_subscription_to_braintree
      if @card_number && @expiration_date && @cvv
        result = Braintree::CreditCard.create(
          :customer_id => customer_id,
          :number => @card_number,
          :expiration_date => @expiration_date,
          :cvv => @cvv
        )
        
        if result.success?
          self.card_token = result.credit_card.token
        end
      end
      
      logger.debug(">>>>>>>#{result.inspect}")
    end
end
