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
     Then I should see "[Brandizzle.com] cartman has invited you to join Brandizzle" in the email subject
     When I click the first link in the email
      And I fill in "Password" with "secret"
      And I fill in "Password confirmation" with "secret"
      And I press "Set up my account and log me in"
     Then I should be on the user edit page for "stan"
      And I should see "Your account has been created!"
  
  Scenario: Updating a user from my team
    Given I am logged in as account holder "cartman"
      And I am on the team page
      And a user "stan" exists with login: "stan", email: "stan@example.com", team: team "cartman_team"
      And I am on the team page
     When I follow "Edit" for user "stan"
     Then I should see "Edit stan's information"
     When I fill in "Password" with "bigger_secret"
      And I fill in "Password confirmation" with "bigger_secret"
      And I press "Update information"
     Then I should be on the team page
      And I should see "Account information updated!"
    
  Scenario: Updating my password
    Given I am logged in as "cartman"
      And I am on the homepage
     When I follow "My info"
      And I fill in "Password" with "better_secret"
      And I fill in "Password confirmation" with "better_secret"
      And I press "Update information"
     Then I should be on the team page
      And I should see "Account information updated!"
  
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