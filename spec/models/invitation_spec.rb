# == Schema Information
#
# Table name: invitations
#
#  id              :integer(4)      not null, primary key
#  sender_id       :integer(4)
#  recipient_email :string(255)
#  token           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Invitation do
  #columns
  should_have_column :recipient_email, :token, :type => :string
  #validations
  should_validate_presence_of :recipient_email
  should_allow_values_for :recipient_email, "foo@example.com", "foo.bar@example.com"
  should_not_allow_values_for :recipient_email, "foo", "", "..."
  
  describe "validate recipient_is_not_registered" do
    it "raises a validation error if recipient is already registered" do
      registered_user = Factory.create(:user, :email => "stan@example.com")
      invitation = Factory.build(:invitation, :recipient_email => "stan@example.com")
      invitation.should have(1).error_on(:recipient_email)
    end
    
    it "is valid if recipient is not registered" do
      registered_user = Factory.create(:user, :email => "stan@example.com")
      invitation = Factory.build(:invitation, :recipient_email => "cartman@example.com")
      invitation.should be_valid
    end
  end
  
  #associations
  should_belong_to :sender, :class_name => "User"
  should_have_one :recipient, :class_name => "User"
end
