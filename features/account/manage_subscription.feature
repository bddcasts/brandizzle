Feature: Managing subscriptions
  In order to continue using my account past the trial period
  As a user
  I want fill in my credit card information
  
  Scenario: Filling in credit card information for the first time
    Given I am logged in as account holder "cartman"
     When I am on the edit account page
      And I fill in the following:
        | First name on card       | Randy            |
        | Last name on card        | Marsh            |
        | Postal code              | 12345            |
        | Card number              | 4111111111111111 |
        | Card verification number | 123              |
      And I select "05" from "account_expiration_month"
      And I select "2015" from "account_expiration_year"
      And I press "Update information" with braintree create
     Then I should be on the account page
      And I should see "Account information updated!"
      And an account should exist with customer_id: "42", card_token: "ctok", subscription_id: "subs"
      # And account: "cartman_account"'s customer_id should be "42"

  Scenario: Updating credit card information
    Given I am logged in as subscribed account holder "cartman"
     When I am on the edit account page
      And I fill in the following:
        | First name on card       | Liane            |
        | Last name on card        | Cartman          |
        | Postal code              | 54321            |
        | Card number              | 5555555555554444 |
        | Card verification number | 123              |
      And I select "08" from "account_expiration_month"
      And I select "2020" from "account_expiration_year"
      And I press "Update information" with braintree update
     Then I should be on the account page
      And I should see "Account information updated!"
      And an account should exist with customer_id: "42", card_token: "ctok", subscription_id: "subs", card_first_name: "Liane"