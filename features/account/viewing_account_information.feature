Feature: Viewing account information
  In order to see how close I am to my account limits
  As a user
  I want to see my account limits
  
  @wip
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
  
  @wip
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

  @wip
  Scenario: Account limits for a subscribed user out of trial, with CC on file
    Given I am logged in as subscribed account holder "cartman" registered "60 days ago"
      And 4 brand queries exist for "cartman"'s team
     When I go to the account page
     Then I should see the following account details:
        | Label             | Value         |
        | Plan              | Standard      |
        | Price             | $29.00/mo     |
        | Your next charge  | July 25, 2010 |
        | Search terms left | 2             |
        | Team members left | 1             |
  
