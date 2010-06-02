When /^I press "([^\"]*)" with braintree create$/ do |button|
  @billing_address = mock("billing_address", 
    :first_name => "Randy",
    :last_name => "Marsh",
    :postal_code => "12345")
  @credit_card = mock("credit_card",
    :token => "ctok",
    :card_type => "Visa",
    :last_4 => "1111",
    :expiration_month => "05",
    :expiration_year => "2020",
    :billing_address => @billing_address)
  @credit_card_response = mock("result", 
    :success? => true, 
    :credit_card => @credit_card)
  
  Braintree::CreditCard.should_receive(:create).and_return(@credit_card_response)
  
  Braintree::Customer.should_receive(:update)
  
  subscription_response = mock("result",
    :success? => true,
    :subscription => mock("subscription", :id => "subs", :status => "Active"))
  
  Braintree::Subscription.should_receive(:create).and_return(subscription_response)
  
  click_button(button)
end

When /^I press "([^\"]*)" with braintree update$/ do |button|
  @billing_address = mock("billing_address", 
    :first_name => "Liane",
    :last_name => "Cartman",
    :postal_code => "54321")
  @credit_card = mock("credit_card",
    :token => "ctok",
    :card_type => "MasterCard",
    :last_4 => "4444",
    :expiration_month => "06",
    :expiration_year => "2012",
    :billing_address => @billing_address)
  @credit_card_response = mock("result", 
    :success? => true, 
    :credit_card => @credit_card)
  
  Braintree::CreditCard.should_receive(:update).and_return(@credit_card_response)
  
  Braintree::Customer.should_receive(:update)
    
  Braintree::Subscription.should_not_receive(:create)
  
  click_button(button)
end