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
  
  describe "#to_s" do
    it "returns the login for the user" do
      user = Factory.build(:user, :login => "Cartman")
      user.to_s.should == "Cartman"
    end
  end
end