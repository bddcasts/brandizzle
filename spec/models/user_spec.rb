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
#  oauth_token       :string(255)     indexed
#  oauth_secret      :string(255)
#  twitter_uid       :string(255)
#  name              :string(255)
#  screen_name       :string(255)
#  location          :string(255)
#  avatar_url        :string(255)
#

require 'spec_helper'

describe User do
  #columns
  should_have_column :login, :email, :crypted_password, :password_salt, :persistence_token, :perishable_token,
                     :oauth_token, :oauth_secret, :twitter_uid, :name, :screen_name, :location, :avatar_url,
                     :type => :string
  
  should_have_column :active, :type => :boolean
  should_have_column :invitation_limit, :type => :integer

  #associations
  should_have_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  should_have_one :account
  should_belong_to :team
  should_have_many :logs
  should_have_many :comments
  
  #validations
  should_validate_presence_of :email, :on => :create
  should_allow_values_for :email, "foo@example.com", "foo.bar@example.com"
  should_not_allow_values_for :email, "foo", "", "..."
  
  describe "#to_s" do
    it "returns the login for the user if name is not set" do
      user = Factory.build(:user, :login => "Cartman")
      user.to_s.should == "Cartman"
    end
    
    it "returns the name of the user if set" do
      user = Factory.build(:twitter_user, :name => "Cartman", :login => nil)
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

  describe "#using_twitter" do
    it "returns true if the user has authorized twitter (oauth_token is set)" do
      user = Factory.build(:twitter_user)
      user.should be_using_twitter
    end
    
    it "returns true if the user has not authorized twitter (oauth_token is not set)" do
      user = Factory.build(:user)
      user.should_not be_using_twitter
    end
  end

  describe "#has_no_credentials?" do
    it "returns true if user has no password set and is not using twitter" do
      user = Factory.create(:user, :password => nil)
      user.should be_has_no_credentials
    end
    
    it "returns false if user has password set" do
      user = Factory.create(:user)
      user.should_not be_has_no_credentials
    end
    
    it "returns false if user is not using twitter" do
      user = Factory.create(:twitter_user, :password => nil)
      user.should_not be_has_no_credentials
    end
  end

  describe "#deliver_password_reset_instructions!" do
    before(:each) do
      @user = Factory.create(:user)
      Notifier.stub(:deliver_password_reset_instructions)
    end

    it "resets the perishable token" do
      @user.should_receive(:reset_perishable_token!)
      @user.deliver_password_reset_instructions!
    end

    it "delivers the password reset instructions using the Notifier" do
      Notifier.should_receive(:deliver_password_reset_instructions).with(@user)
      @user.deliver_password_reset_instructions!
    end
  end
  
  describe "#deliver_user_invitation!" do
    before(:each) do
      @user = Factory.create(:user)
      Notifier.stub(:deliver_user_invitation)
    end

    it "resets the perishable token" do
      @user.should_receive(:reset_perishable_token!)
      @user.deliver_user_invitation!
    end

    it "delivers the invitation using the Notifier" do
      Notifier.should_receive(:deliver_user_invitation).with(@user)
      @user.deliver_user_invitation!
    end
  end

  it "sets invitation limit on create" do
    user = Factory.create(:user)
    user.invitation_limit.should == Settings.invitations.limit
  end
  
  describe "populate user data from Twitter profile" do
    describe "on save" do
      it "does not overwrite existing data" do
        user = Factory.create(:twitter_user)
        UserSession.oauth_consumer.should_not_receive(:request)
        user.save
      end
    end
    
    describe "on create" do
      before(:each) do
        @user = Factory.build(:twitter_user, :twitter_uid => nil)
        @user.stub!(:access_token).and_return("the-access-token")
        @twitter_response = mock("Twitter HTTP Response", :body => "{}")
        UserSession.stub_chain(:oauth_consumer, :request).and_return(@twitter_response)
      end
      
      it "does nothing if not using Twitter" do
        user = Factory.build(:user)
        UserSession.oauth_consumer.should_not_receive(:request)
        user.save
      end
      
      it "fetches the user profile information from Twitter if using OAuth" do
        UserSession.oauth_consumer.
          should_receive(:request).
          with(:get, '/account/verify_credentials.json', @user.send(:access_token), { :scheme => :query_string }).
          and_return(@twitter_response)
        
        @user.save
      end
      
      it "sets the user's attributes to the ones in the user's Twitter profile" do
        attribute_mapping = {
          :name => "name",
          :id => "twitter_uid",
          :screen_name => "screen_name",
          :location => "location",
          :profile_image_url => "avatar_url"
        }
        
        fetched_attributes = {
          :name => "Twitter Guy",
          :screen_name => "twitter_guy",
          :id => "123456",
          :location => "NY",
          :profile_image_url => "http://twitter.com/123456/avatar.png"
        }
        
        @twitter_response.should_receive(:is_a?).and_return(true)
        @twitter_response.stub!(:body).and_return(fetched_attributes.to_json)
        
        fetched_attributes.each do |key, value|
          @user.should_receive("#{attribute_mapping[key]}=").with(value)
        end
        
        @user.save
      end
    end
  end
end

