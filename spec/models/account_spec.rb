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

require 'spec_helper'

describe Account do
  #columns
  should_have_column :plan_id, :customer_id, :card_token, :subscription_id, :card_type, :card_number_last_4_digits, :status, :type => :string
  
  #validations
  should_validate_presence_of :holder
  should_validate_associated :holder
  
  #associations
  should_belong_to :holder, :class_name => "User", :foreign_key => "user_id"
  should_have_one :team
  should_accept_nested_attributes_for :holder
end
