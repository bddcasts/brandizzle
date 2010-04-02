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

require 'spec_helper'

describe Account do
  #validations
  should_validate_presence_of :holder
  should_validate_associated :holder
  
  #associations
  should_belong_to :holder, :class_name => "User", :foreign_key => "user_id"
  should_belong_to :invitation
  should_have_one :team
  should_accept_nested_attributes_for :holder
end
