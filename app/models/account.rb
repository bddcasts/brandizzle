# == Schema Information
#
# Table name: accounts
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Account < ActiveRecord::Base
  belongs_to :holder, :class_name => "User", :foreign_key => "user_id"
  has_one :team
  
  has_one :subscription, :dependent => :destroy
  
  accepts_nested_attributes_for :holder, :subscription
  
  validates_presence_of :holder
  validates_associated :holder
  
  before_save :save_customer_to_braintree
  
  private
    def save_customer_to_braintree
      unless subscription.customer_id
        result = Braintree::Customer.create(:email => holder.email)
        if result.success?
          subscription.customer_id = result.customer.id
        end
      end
      
      logger.debug(">>>>>>>>>#{result.inspect}")
    end
end
