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

require 'spec_helper'

describe Account do
  #columns
  should_have_column :plan_id, :customer_id, :card_token, :status, :type => :string
  should_have_column :subscription_id, :type => :integer
  
  #validations
  should_validate_presence_of :holder
  should_validate_associated :holder
  
  #associations
  should_belong_to :holder, :class_name => "User", :foreign_key => "user_id"
  should_have_one :team
  should_accept_nested_attributes_for :holder
end
