# == Schema Information
#
# Table name: accounts
#
#  id            :integer(4)      not null, primary key
#  user_id       :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  invitation_id :string(255)
#

class Account < ActiveRecord::Base
  belongs_to :holder, :class_name => "User", :foreign_key => "user_id"
  belongs_to :invitation
  has_one :team
  
  has_one :subscription, :dependent => :destroy
  
  accepts_nested_attributes_for :holder, :subscription
  
  validates_presence_of :holder
  validates_associated :holder
  validates_presence_of :invitation_id, :message => 'Invitation is required'
  validates_uniqueness_of :invitation_id, :message => 'Invitation has already been used'
  
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
