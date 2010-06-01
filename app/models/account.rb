# == Schema Information
#
# Table name: accounts
#
#  id                        :integer(4)      not null, primary key
#  user_id                   :integer(4)
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :string(255)
#  last_name                 :string(255)
#  postal_code               :string(255)
#  plan_id                   :string(255)
#  customer_id               :string(255)
#  card_token                :string(255)
#  subscription_id           :string(255)
#  status                    :string(255)
#  card_type                 :string(255)
#  card_number_last_4_digits :string(255)
#  card_expiration_date      :string(255)
#

class Account < ActiveRecord::Base
  belongs_to :holder, :class_name => "User", :foreign_key => "user_id"
  has_one :team
    
  accepts_nested_attributes_for :holder
  
  validates_presence_of :holder
  validates_associated :holder
  validate :save_card_to_braintree, :if => :card_fields_present?
  validates_presence_of :first_name, :if => :card_fields_present?
  validates_presence_of :last_name, :if => :card_fields_present?
  validates_presence_of :postal_code, :if => :card_fields_present?
  
  after_create :create_braintree_customer
  after_save :create_braintree_subscription, :if => :subscription_needed?
  
  attr_accessor :card_number, :expiration_month, :expiration_year, :cvv
  
  def card_fields_present?
    !@card_number.blank? && !@expiration_month.blank? && !@expiration_year.blank? && !@cvv.blank?
  end
  
  def trial_days_left
    (30 - (Time.now - created_at)/1.day).round
  end
  
  def subscription_needed?
    card_token && !subscription_id
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
      if card_token
        result = Braintree::CreditCard.update(card_token,
          :cardholder_name =>  [first_name, last_name].join(" "),
          :number => @card_number,
          :expiration_month => @expiration_month,
          :expiration_year => @expiration_year,
          :cvv => @cvv,
          :billing_address => {
            :first_name => first_name,
            :last_name => last_name,
            :postal_code => postal_code,
            :options => { :update_existing => true }
            },
          :options => { :verify_card => true }
        )
      else
        result = Braintree::CreditCard.create(
          :customer_id => customer_id,
          :cardholder_name =>  [first_name, last_name].join(" "),
          :number => @card_number,
          :expiration_month => @expiration_month,
          :expiration_year => @expiration_year,
          :cvv => @cvv,
          :billing_address => {
            :first_name => first_name,
            :last_name => last_name,
            :postal_code => postal_code
            },
          :options => { :verify_card => true }
        )
      end
      
      if result.success?
        self.card_token = result.credit_card.token
        self.card_type = result.credit_card.card_type
        self.card_number_last_4_digits = result.credit_card.last_4
        self.card_expiration_date = [result.credit_card.expiration_month, result.credit_card.expiration_year].join("/")
        
        update_braintree_customer
        @card_number, @expiration_date, @cvv = nil
      else
        errors.add_to_base("Card is invalid")
      end
    end
    
    def create_braintree_subscription
      result = Braintree::Subscription.create(
        :payment_method_token => card_token,
        :plan_id => plan_id,
        :trial_period => true,
        :trial_duration => trial_days_left,
        :trial_duration_unit => Braintree::Subscription::TrialDurationUnit::Day
      )

      if result.success?
        self.subscription_id = result.subscription.id
        self.status = result.subscription.status
        save!
      end
    end
    
    def update_braintree_customer
      result = Braintree::Customer.update(customer_id,
        :first_name => first_name,
        :last_name => last_name
      )
    end
end
