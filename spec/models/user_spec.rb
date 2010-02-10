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
  should_validate_presence_of :invitation_id, :message => 'Invitation is required' #with invitations

  #associations
  should_have_many :brands
  
  should_have_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id' #with invitations
  should_belong_to :invitation #with invitations
  
  #without invitations
  # describe "#active?" do
  #   it "returns true if user is active" do
  #     user = Factory.build(:user)
  #     user.active?.should be_true
  #   end
  #   
  #   it "returns false if user is not active" do
  #     user = Factory.build(:inactive_user)
  #     user.active?.should be_false
  #   end
  # end

  #without invitations
  # describe "#activate!" do
  #   it "sets the active attribute to true and saves the user" do
  #     user = Factory.create(:inactive_user)
  #     user.activate!
  #     user.active?.should be_true
  #   end
  # end

  describe "#to_s" do
    it "returns the login for the user" do
      user = Factory.build(:user, :login => "Cartman")
      user.to_s.should == "Cartman"
    end
  end
end