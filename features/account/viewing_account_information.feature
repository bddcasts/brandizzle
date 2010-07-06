Feature: Viewing account information
  In order to see how close I am to my account limits
  As a user
  I want to see my account limits
  
  Scenario: Account limits for a user in trial without CC on file
    Given I am logged in as account holder "cartman" registered "20 days ago"
      And 4 brand queries exist for "cartman"'s team
     When I go to the edit account page
     Then I should see the following account details:
        | Label                 | Value                  |
        | Plan                  | Standard               |
        | Price                 | $29.00/mo              |
        | Your trial expires on | date(10 days from now) |
        | Search terms left     | 2                      |
        | Team members left     | 1                      |
  
  Scenario: Account limits for a subscribed user still in trial, but with CC on file
    Given I am logged in as subscribed account holder "cartman" registered "10 days ago"
      And 4 brand queries exist for "cartman"'s team
     When I go to the account page
     Then I should see the following account details:
        | Label                 | Value                  |
        | Plan                  | Standard               |
        | Price                 | $29.00/mo              |
        | Your trial expires on | date(20 days from now) |
        | Your next charge      | date(20 days from now) |
        | Search terms left     | 2                      |
        | Team members left     | 1                      |

  Scenario: Account limits for a subscribed user out of trial, with CC on file
    Given I am logged in as subscribed account holder "cartman" registered "50 days ago"
      And 4 brand queries exist for "cartman"'s team
     When I go to the account page
     Then I should see the following account details:
        | Label             | Value                  |
        | Plan              | Standard               |
        | Price             | $29.00/mo              |
        | Your next charge  | date(11 days from now) |
        | Search terms left | 2                      |
        | Team members left | 1                      |
  
  Scenario: Viewing my payment history
    Given I am logged in as subscribed account holder "cartman"
      And a subscription_transaction exists with account: account "cartman_account", amount: "29.0"
     When I am on the account page
     Then I should see "Payments history"
      And I should see "29.0"
  
  Scenario: Viewing a payment
    Given I am logged in as subscribed account holder "cartman"
      And a subscription_transaction exists with account: account "cartman_account", amount: "29.0"
      And I am on the account page
     When I follow "Receipt"
     Then I should see "29.0"
  