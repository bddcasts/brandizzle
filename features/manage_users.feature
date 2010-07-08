Feature: Account management
  In order to keep my account up to date
  As a registered user
  I want to manage my account information
  
  Scenario: Creating a new user for my team
    Given I am logged in as account holder "cartman"
      And I am on the team page
     When I follow "Create a new user"
      And I fill in "Login" with "stan"
      And I fill in "Email" with "stan@example.com"
      And I press "Create user"
     Then I should be on the team page
      And I should see "The user has been created."
      And I should see "stan@example.com"
      And a user should exist with login: "stan", email: "stan@example.com"
      And I follow "Sign out"
      
     Then "stan@example.com" should receive an email
     When I open the email
     Then I should see "[BrandPulse] cartman has invited you to join BrandPulse" in the email subject
     When I click the first link in the email
      And I fill in "Password" with "secret"
      And I fill in "Password confirmation" with "secret"
      And I check "I agree to the terms of use."
      And I press "Set up my account and log me in"
     Then I should be on the homepage
      And I should see "Your account has been activated!"
    
  Scenario: Removing a user from my team
    Given I am logged in as account holder "cartman"
      And a user "stan" exists with login: "stan", email: "stan@example.com", team: team "cartman_team"
      And I am on the team page
     When I follow "Remove" for user "stan"
     Then I should be on the team page
      And I should see "Successfully removed!"
      And I should not see "stan@example.com"
  
  Scenario: Disabling a user from my team
    Given I am logged in as account holder "cartman"
      And a user "stan" exists with login: "stan", email: "stan@example.com", team: team "cartman_team"
      And I am on the team page
     When I follow "Disable" for user "stan"
     Then I should be on the team page
      And I should see "User disabled!"
      And I should see "Enable" for user "stan"
      
  Scenario: Enabling an inactive user from my team
    Given I am logged in as account holder "cartman"
      And an inactive user "stan" exists with login: "stan", email: "stan@example.com", team: team "cartman_team"
      And I am on the team page
     When I follow "Enable" for user "stan"
     Then I should be on the team page
      And I should see "User enabled!"
      And I should see "Disable" for user "stan"
      
  Scenario: Trying to create a new user when account has reached team members limit
    Given I am logged in as subscribed account holder "cartman"
      And a user "stan" exists with login: "stan", email: "stan@example.com", team: team "cartman_team"
      And I am on the team page
     When I follow "Create a new user"
      And I fill in "Login" with "kenny"
      And I fill in "Email" with "kenny@example.com"
      And I press "Create user"
     Then I should be on my account page
      And I should see "You reached the limit of team members. User registration failed."
      And a user should not exist with login: "kenny", email: "kenny@example.com", team: team "cartman_team"
  
  Scenario: Trying to create a new user when not account holder
    Given I am logged in as "cartman"
     When I go to the team: "cartman_team"'s new user page
     Then I should be on the team page
      And I should see "Access denied! Only the account holder can modify settings."
  