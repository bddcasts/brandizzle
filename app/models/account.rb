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
#  card_first_name           :string(255)
#  card_last_name            :string(255)
#  card_postal_code          :string(255)
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
  
  after_create :create_braintree_customer
  after_save :create_braintree_subscription, :if => :subscription_needed?
  
  attr_accessor :card_number, :expiration_month, :expiration_year, :cvv, :first_name, :last_name, :postal_code
  
  def card_fields_present?
    !@card_number.blank? && !@expiration_month.blank? && !@expiration_year.blank? && !@cvv.blank? && !@first_name.blank? && !@last_name.blank? && !@postal_code.blank?
  end
  
  def trial_days_left
    [(30 - (Time.now - created_at)/1.day).round, 0].max
  end
  
  def valid_subscription?
    comp? || (subscription_id && status == 'Active') || trial_days_left > 0
  end
  
  def subscription_needed?
    card_token && !subscription_id
  end
  
  def have_card_on_file?
    !!card_token
  end
  
  def plan
    !plan_id.blank? && Plan.send(plan_id)
  end
  
  def trial?
    trial_days_left > 0
  end
  
  private
    def create_braintree_customer
      result = Braintree::Customer.create(:email => holder.email)
      if result.success?
        self.update_attribute(:customer_id, result.customer.id)
      end
    end
    
    def save_card_to_braintree
      if card_token
        result = Braintree::CreditCard.update(
          card_token,
          braintree_credit_card_attr.merge(
            :billing_address => braintree_billing_address_attr.merge(
              :options => { :update_existing => true}))
        )
      else
        result = Braintree::CreditCard.create(
          braintree_credit_card_attr.merge(
            :customer_id => customer_id, :billing_address => braintree_billing_address_attr)
        )
      end
      
      if result.success?
        self.card_token = result.credit_card.token
        self.card_type = result.credit_card.card_type
        self.card_number_last_4_digits = result.credit_card.last_4
        self.card_expiration_date = [result.credit_card.expiration_month, result.credit_card.expiration_year].join("/")
        self.card_first_name = result.credit_card.billing_address.first_name
        self.card_last_name = result.credit_card.billing_address.last_name
        self.card_postal_code = result.credit_card.billing_address.postal_code
        
        update_braintree_customer
        @card_number = nil #settings card_number to nil so when subscription is saved card does not get saved again
      else
        errors.add_to_base("Invalid Credit Card!")
        errors.add(:card_number, "is invalid") if result.errors.for(:credit_card)
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
      else
        logger.error("Count not create subscription. Details: #{result.inspect}")
      end
    end
    
    def update_braintree_customer
      result = Braintree::Customer.update(customer_id,
        :first_name => first_name,
        :last_name => last_name
      )
    end
    
    def braintree_credit_card_attr
      {
        :cardholder_name =>  [@first_name, @last_name].join(" "),
        :number => @card_number,
        :expiration_month => @expiration_month,
        :expiration_year => @expiration_year,
        :cvv => @cvv,
        :options => { :verify_card => true }
      }
    end
    
    def braintree_billing_address_attr
      {
        :first_name => @first_name,
        :last_name => @last_name,
        :postal_code => @postal_code
      }
    end
end
