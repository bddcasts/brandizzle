# == Schema Information
#
# Table name: accounts
#
#  id                        :integer(4)      not null, primary key
#  user_id                   :integer(4)
#  created_at                :datetime
#  updated_at                :datetime
#  plan_id                   :string(255)
#  customer_id               :string(255)
#  card_token                :string(255)
#  subscription_id           :string(255)
#  status                    :string(255)
#  card_first_name           :string(255)
#  card_last_name            :string(255)
#  card_postal_code          :string(255)
#  card_type                 :string(255)
#  card_number_last_4_digits :string(255)
#  card_expiration_date      :string(255)
#

require 'spec_helper'

describe Account do
  #columns
  should_have_column :plan_id, :customer_id, :card_token, :subscription_id, :status, 
    :card_type, :card_first_name, :card_last_name, :card_postal_code, :card_expiration_date, :card_number_last_4_digits,
    :type => :string
  
  #validations
  should_validate_presence_of :holder
  should_validate_associated :holder
  
  #associations
  should_belong_to :holder, :class_name => "User", :foreign_key => "user_id"
  should_have_one :team
  should_accept_nested_attributes_for :holder
  
  let(:valid_credit_card_fields) do
    {
      :card_number      => "4111111111111111",
      :expiration_month => "05",
      :expiration_year  => "2020",
      :cvv              => "123",
      :first_name       => "Randy",
      :last_name        => "Marsh",
      :postal_code      => "12345"
    }
  end
  
  it { should_not be_comp }
 
  it "creating a new account also creates a braintree account and sets customer_id" do
    create_customer_result = mock("result", :success? => true, :customer => mock("customer", :id => "42"))
    Braintree::Customer.should_receive(:create).and_return(create_customer_result)
    
    account = Factory.create(:account)
    account.customer_id.should == "42"
  end
  
  describe "updating account with credit card details" do
    subject                    { Factory.create(:account, :customer_id => customer_id, :card_token => card_token) }
    let(:customer_id)          { "customer-42" }
    let(:billing_address)      { mock("billing_address", :first_name => "Randy", :last_name => "Marsh", :postal_code => "12345") }
    let(:credit_card)          { mock("credit_card", :token => "asdf", :card_type => "Visa", :last_4 => "1111", :expiration_month => "05", :expiration_year => "2020", :billing_address => billing_address) }
    let(:credit_card_response) { mock("result", :success? => true, :credit_card => credit_card) }
    
    before(:each) do
      create_customer_result = mock("result", :success? => true, :customer => mock("customer", :id => customer_id))
      Braintree::Customer.stub(:create).and_return(create_customer_result)
      Braintree::Customer.stub(:update).and_return(mock("result", :null_object => true))
      Braintree::Subscription.stub(:create).and_return(mock("result", :null_object => true))
      Braintree::CreditCard.stub(:create).and_return(mock("result", :null_object => true))
      Braintree::CreditCard.stub(:update).and_return(mock("result", :null_object => true))
    end
    
    context "card_token does not exist" do
      let(:card_token) { nil }     
      
      it "creates a new credit card on braintree and populates account fields with braintree result attributes" do
        Braintree::CreditCard.should_receive(:create).and_return(credit_card_response)

        subject.update_attributes(valid_credit_card_fields)
        
        subject.card_token.should == "asdf"
        subject.card_type.should == "Visa"
        subject.card_number_last_4_digits.should == "1111"
        subject.card_expiration_date.should == "05/2020"
        subject.card_first_name.should == "Randy"
        subject.card_last_name.should == "Marsh"
        subject.card_postal_code.should == "12345"
      end
      
      it "updates the customer on braintree with first_name and last_name" do
        Braintree::Customer.should_receive(:update).
          with(customer_id, hash_including(:first_name => "Randy", :last_name => "Marsh"))
        
        subject.update_attributes(valid_credit_card_fields)
      end
    end

    context "card_token exists" do
      let(:card_token) { "card-token" }
      
      it "creates a new subscription on braintree and sets the subscription_id and status for account" do
        subscription_response = mock("result",
          :success? => true,
          :subscription => mock("subscription", :id => "subs", :status => "Active"))
        
        Braintree::Subscription.should_receive(:create).and_return(subscription_response)
        
        subject.update_attributes(valid_credit_card_fields)
        
        subject.subscription_id.should == "subs"
        subject.status.should == "Active"
      end
      
      it "updates the existing credit card on braintree and populates account fields with braintree result attributes" do
        Braintree::CreditCard.should_receive(:update).and_return(credit_card_response)
        
        subject.update_attributes(valid_credit_card_fields)
        
        subject.first_name.should == "Randy"
      end
    end
  end
  
  describe "#trial_days_left" do
    before(:each) do
      @result = mock("result", :success? => true, :null_object => true)
      Braintree::Customer.stub!(:create).and_return(@result)
    end
    
    context "within the trial period" do
      subject { Factory.create(:account, :created_at => 3.days.ago) }
      
      it "fetches the number of trial days left" do
        subject.trial_days_left.should == 27
      end
    end
    
    context "outside the trial period" do
      subject { Factory.create(:account, :created_at => 420.days.ago) }
      
      it "fetches the number of trial days left" do
        subject.trial_days_left.should == 0
      end
    end
  end
  
  describe "valid_subscription?" do
    subject { Factory.create(:account, :subscription_id => subscription_id, :status => status, :created_at => created_at, :comp => comp) }
    let(:comp) { false }
    
    before(:each) do
      create_customer_result = mock("result", :success? => true, :customer => mock("customer", :id => "42"))
      Braintree::Customer.stub(:create).and_return(create_customer_result)
    end
    
    context "comped" do
      let(:comp) { true }
      let(:subscription_id) { nil }
      let(:status) { "PastDue" }
      let(:created_at) { 300.days.ago }
      
      it "returns true" do
        subject.valid_subscription?.should be_true
      end
    end
    
    context "subscription_id present, status active, trial days left" do
      let(:subscription_id) { "subs-id" }
      let(:status) { "Active" }
      let(:created_at) { 3.days.ago }
      
      it "returns true" do
        subject.valid_subscription?.should be_true
      end
    end
    
    context "subscription_id present, status active, no trial days left" do
      let(:subscription_id) { "subs-id" }
      let(:status) { "Active" }
      let(:created_at) { 31.days.ago}
      
      it "returns true" do
        subject.valid_subscription?.should be_true
      end
    end
    
    context "no subscription_id, trial days left" do
      let(:subscription_id) { nil }
      let(:status) { "Active" }
      let(:created_at) { 3.days.ago }
      
      it "returns true" do
        subject.valid_subscription?.should be_true
      end
    end
    
    context "no subscription_id, no trial days left" do
      let(:subscription_id) { nil }
      let(:status) { "Active" }
      let(:created_at) { 31.days.ago }
      
      it "returns false" do
        subject.valid_subscription?.should be_false
      end      
    end
    
    context "subscription_id present, status not active, no trial days left" do
      let(:subscription_id) { "subs-id" }
      let(:status) { "PastDue" }
      let(:created_at) { 31.days.ago }
      
      it "returns false" do
        subject.valid_subscription?.should be_false
      end
    end
  end
  
  describe "#card_fields_present?" do
    subject { Account.new(valid_credit_card_fields) }

    it "returns true if all card fields are present" do
      subject.card_fields_present?.should be_true
    end
    
    ["card_number", "expiration_month", "expiration_year", "cvv", "first_name", "last_name", "postal_code"].each do |att|
      it "returns false if #{att} is not present" do
        subject.send("#{att}=", nil)
        subject.card_fields_present?.should be_false
      end
    end
  end

  describe "#subscription_needed?" do
    subject { Account.new(:card_token => card_token, :subscription_id => subscription_id) }
    let(:card_token) { "card-token" }
    let(:subscription_id) { "subs-id"}
    
    before(:each) do
     result = mock("result", :success? => true, :null_object => true)
     Braintree::Customer.stub!(:create).and_return(result)
     Braintree::CreditCard.stub!(:create).and_return(result)
     Braintree::Subscription.stub!(:create).and_return(result)
    end

    context "card_token present subscription_id not present" do
      let(:subscription_id) { nil }
      
      it "returns true" do
        subject.subscription_needed?.should be_true
      end
    end
    
    context "card_token not present" do
      let(:card_token) { nil }
      
      it "returns false" do
       subject.subscription_needed?.should be_false
      end
    end
    
    context "card_token present and subscription_id present" do
      it "returns false" do
       subject.subscription_needed?.should be_false
      end
    end
  end
  
  describe "#have_card_on_file?" do
    subject { Account.new(:card_token => token).have_card_on_file? }
    
    context "when a BrainTree card token is present" do
      let(:token) { "present" }
      
      it { should be_true }
    end
    
    context "when the BrainTree card token is nil" do
      let(:token) { nil }
      
      it { should be_false }
    end
  end
end
