# == Schema Information
#
# Table name: accounts
#
#  id                        :integer(4)      not null, primary key
#  user_id                   :integer(4)
#  created_at                :datetime
#  updated_at                :datetime
#  plan_id                   :string(255)
#  customer_id               :string(255)
#  card_token                :string(255)
#  subscription_id           :string(255)
#  status                    :string(255)
#  card_type                 :string(255)
#  card_number_last_4_digits :string(255)
#

class Account < ActiveRecord::Base
  belongs_to :holder, :class_name => "User", :foreign_key => "user_id"
  has_one :team
    
  accepts_nested_attributes_for :holder
  
  validates_presence_of :holder
  validates_associated :holder
  # validate :save_card_to_braintree
  
  after_create :create_braintree_customer
  
  before_save :save_card_to_braintree
  before_save :save_subscription_to_braintree
  
  attr_accessor :card_number, :expiration_date, :cvv
  
  def card_fields?
    !@card_number.blank? && !@expiration_date.blank? && !@cvv.blank?
  end
  
  def trial_days_left
    (30 - (Time.now - created_at)/86400).round
  end
  
  private
    def create_braintree_customer
      result = Braintree::Customer.create(:email => holder.email)

      if result.success?
        self.customer_id = result.customer.id
        self.save
      end
    end
    
    def save_card_to_braintree
      if card_fields?
        if card_token
          result = Braintree::CreditCard.update(card_token,
            :number => @card_number,
            :expiration_date => @expiration_date,
            :cvv => @cvv,
            :options => { :verify_card => true }
          )
        else
          result = Braintree::CreditCard.create(
            :customer_id => customer_id,
            :number => @card_number,
            :expiration_date => @expiration_date,
            :cvv => @cvv,
            :options => { :verify_card => true }
          )
        end
        
        if result.success?
          self.card_token = result.credit_card.token
          self.card_type = result.credit_card.card_type
          self.card_number_last_4_digits = result.credit_card.last_4
        else
          errors.add_to_base("Card is invalid")
        end
      end
    end
    
    def save_subscription_to_braintree
      if card_token 
        if subscription_id
          Braintree::Subscription.update(subscription_id,
            :payment_method_token => card_token
          )
        else
          result = Braintree::Subscription.create(
            :payment_method_token => card_token,
            :plan_id => plan_id,
            :trial_duration => trial_days_left,
            :trial_duration_unit => Braintree::Subscription::TrialDurationUnit::Day
          )
        end

        if result.success?
          self.subscription_id = result.subscription.id
        end
      end
    end
end
