# == Schema Information
#
# Table name: accounts
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  plan_id         :string(255)
#  customer_id     :string(255)
#  card_token      :string(255)
#  subscription_id :integer(4)
#  status          :string(255)
#

class Account < ActiveRecord::Base
  belongs_to :holder, :class_name => "User", :foreign_key => "user_id"
  has_one :team
    
  accepts_nested_attributes_for :holder
  
  validates_presence_of :holder
  validates_associated :holder
  
  # before_save :save_customer_to_braintree
  # 
  # private
  #   def save_customer_to_braintree
  #     unless subscription.customer_id
  #       result = Braintree::Customer.create(:email => holder.email)
  #       if result.success?
  #         subscription.customer_id = result.customer.id
  #       end
  #     end
  #   end
end
