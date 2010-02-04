Feature: Account management
  In order to keep my account up to date
  As a registered user
  I want to manage my account information
  
  Scenario: Visiting my account
    Given I am logged in
      And I am on the homepage
     When I follow "My account"
     Then I should be on my account page
      And I should see "Edit your account information"
  
  Scenario: Update password
    Given I am logged in
      And I am on my account page
      And I fill in "Password" with "better_secret"
      And I fill in "Password confirmation" with "better_secret"
      And I press "Update information"
     Then I should be on my account page
      And I should see "Account information updated!"