# == Schema Information
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  login             :string(255)     not null
#  email             :string(255)     not null, indexed
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)     not null
#  perishable_token  :string(255)     not null, indexed
#  active            :boolean(1)      default(TRUE), not null
#  created_at        :datetime
#  updated_at        :datetime
#  invitation_limit  :integer(4)      default(0)
#  team_id           :integer(4)
#

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


  #associations
  should_have_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  should_have_one :account
  should_belong_to :team
  
  describe "#to_s" do
    it "returns the login for the user" do
      user = Factory.build(:user, :login => "Cartman")
      user.to_s.should == "Cartman"
    end
  end
  
  describe "#toggle_active" do
    it "should set active to true if set to false" do
      @user = Factory.create(:inactive_user)
      @user.toggle_active
      @user.should be_active
    end
    
    it "should set active to false if set to true" do
      @user = Factory.create(:user)
      @user.toggle_active
      @user.should_not be_active
    end
  end
    
  describe "#account_holder?" do
    it "returns true if the specified user is account holder" do
      user = Factory.build(:user, :account => Factory.build(:account))
      user.should be_account_holder
    end
    
    it "returns false if the specified user is not account holder" do
      user = Factory.build(:user)
      user.should_not be_account_holder
    end
  end
end

