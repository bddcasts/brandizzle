require 'spec_helper'

describe User do
  #columns
  should_have_column :login,
                     :email,
                     :crypted_password,
                     :password_salt,
                     :persistence_token,
                     :perishable_token,
                     :type => :string

  #validations
  should_validate_presence_of :invitation_id, :message => 'Invitation is required'

  #associations
  should_have_many :brands
  
  should_have_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  should_belong_to :invitation
  
  describe "#to_s" do
    it "returns the login for the user" do
      user = Factory.build(:user, :login => "Cartman")
      user.to_s.should == "Cartman"
    end
  end
end