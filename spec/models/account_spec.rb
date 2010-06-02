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
 
  it "creating a new account also creates a braintree account and sets customer_id" do
    create_customer_result = mock("result", :success? => true, :customer => mock("customer", :id => "42"))
    Braintree::Customer.should_receive(:create).and_return(create_customer_result)
    
    account = Factory.create(:account)
    account.customer_id.should == "42"
  end
  
  describe "updating account with credit card details" do
    before(:each) do
      create_customer_result = mock("result", :success? => true, :customer => mock("customer", :id => "42"))
      Braintree::Customer.stub!(:create).and_return(create_customer_result)
      
      @billing_address = mock("billing_address", 
        :first_name => "Randy",
        :last_name => "Marsh",
        :postal_code => "12345")
      @credit_card = mock("credit_card",
        :token => "asdf",
        :card_type => "Visa",
        :last_4 => "1111",
        :expiration_month => "05",
        :expiration_year => "2020",
        :billing_address => @billing_address)
      @credit_card_response = mock("result", 
        :success? => true, 
        :credit_card => @credit_card)
    end
    
    context "card_token does not exist" do      
      it "creates a new credit card on braintree and populates account fields with braintree result attributes" do
        Braintree::Customer.stub!(:update).and_return(mock("result", :null_object => true))
        Braintree::Subscription.stub!(:create).and_return(mock("result", :null_object => true))
                  
        Braintree::CreditCard.should_receive(:create).and_return(@credit_card_response)
        
        account = Factory.create(:account)
        valid_credit_card_fields.each do |k,v|
          account.send("#{k}=", v)
        end
        account.save
        
        account.card_token.should == "asdf"
        account.card_type.should == "Visa"
        account.card_number_last_4_digits.should == "1111"
        account.card_expiration_date.should == "05/2020"
        account.card_first_name.should == "Randy"
        account.card_last_name.should == "Marsh"
        account.card_postal_code.should == "12345"
      end
      
      it "updates the customer on braintree with first_name and last_name" do
        Braintree::Subscription.stub!(:create).and_return(mock("result", :null_object => true))
        Braintree::CreditCard.stub!(:create).and_return(mock("result", :null_object => true))
        
        account = Factory.create(:account, :customer_id => "test")
                
        Braintree::Customer.should_receive(:update).
          with(account.customer_id, hash_including(:first_name => "Randy", :last_name => "Marsh"))
      
        valid_credit_card_fields.each do |k,v|
          account.send("#{k}=", v)
        end
        account.save
      end
    end

    context "card_token exists" do
      it "creates a new subscription on braintree and sets the subscription_id and status for account" do
        Braintree::Customer.stub!(:update).and_return(mock("result", :null_object => true))
        Braintree::CreditCard.stub!(:update).and_return(mock("result", :null_object => true))
        
        subscription_response = mock("result",
          :success? => true,
          :subscription => mock("subscription", :id => "subs", :status => "Active"))
        
        Braintree::Subscription.should_receive(:create).and_return(subscription_response)
        
        account = Factory.create(:account, :card_token => "test")
        valid_credit_card_fields.each do |k,v|
          account.send("#{k}=", v)
        end
        account.save
        
        account.subscription_id.should == "subs"
        account.status.should == "Active"
      end
      
      it "updates the existing credit card on braintree and populates account fields with braintree result attributes" do
        Braintree::Customer.stub!(:update).and_return(mock("result", :null_object => true))
        Braintree::Subscription.stub!(:create).and_return(mock("result", :null_object => true))
        
        Braintree::CreditCard.should_receive(:update).and_return(@credit_card_response)
        
        account = Factory.create(:account, :card_token => "test", :card_first_name => "Stan")
        valid_credit_card_fields.each do |k,v|
          account.send("#{k}=", v)
        end
        account.save
        account.first_name.should == "Randy"
      end
    end
  end
  
  describe "#trial_days_left" do
    before(:each) do
      @result = mock("result", :success? => true, :null_object => true)
      Braintree::Customer.stub!(:create).and_return(@result)
    end
    
    it "fetches the number of trial days left" do
      account = Factory.create(:account, :created_at => 3.days.ago)
      account.trial_days_left.should == 27
    end
  end
  
  describe "#card_fields_present?" do
    before(:each) do
      @account = Account.new(valid_credit_card_fields)
    end
    
    it "returns true if all card fields are present" do
      @account.card_fields_present?.should be_true
    end
    
    ["card_number", "expiration_month", "expiration_year", "cvv", "first_name", "last_name", "postal_code"].each do |att|
      it "returns false if #{att} is not present" do
        @account.send("#{att}=", nil)
        @account.card_fields_present?.should be_false
      end
    end
  end

  describe "#subscription_needed?" do
    before(:each) do
     @result = mock("result", :success? => true, :null_object => true)
     Braintree::Customer.stub!(:create).and_return(@result)
     Braintree::CreditCard.stub!(:create).and_return(@result)
     Braintree::Subscription.stub!(:create).and_return(@result)
    end

    it "returns true if card_token present and subscription_id not present" do
     account = Account.new(:card_token => "123", :subscription_id => nil)
     account.subscription_needed?.should be_true
    end

    it "returns false if card_token is not present" do
     account = Account.new(:card_token => nil)
     account.subscription_needed?.should be_false
    end

    it "returns false if card_token present and subscription_id present" do
     account = Account.new(:card_token => "123", :subscription_id => "123")
     account.subscription_needed?.should be_false
    end
  end
  
  private
    def valid_credit_card_fields
      {
        :card_number => "4111111111111111",
        :expiration_month => "05",
        :expiration_year => "2020",
        :cvv => "123",
        :first_name => "Randy",
        :last_name => "Marsh",
        :postal_code => "12345"
      }
    end
end
