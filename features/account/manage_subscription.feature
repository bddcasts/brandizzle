Feature: Managing subscriptions
  In order to continue using my account past the trial period
  As a user
  I want fill in my credit card information

  Background:
    Given I am logged in as account holder "cartman"

  @wip
  Scenario: Filling in credit card information for the first time
    Given I am on the edit account page
     When I fill in "Card number" with "4111111111111111"
      And I fill in "Expiration date" with "01/2012"
      And I fill in "Card verification number" with "123"
      And I press "Update information"
     Then I should be on the edit account page
      And I should see "Account information updated!"
      