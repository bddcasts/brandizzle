Feature: User Accounts
  In order to manage my brands and search terms
  As a user
  I want to register for an account, login and logout
  
  Scenario: Visiting the registration page
    Given I am on the homepage
     When I follow "Sign Up"
     Then I should be on the registration page
      And I should see "Register for an account"

  Scenario: Registering for a new account
    Given I am on the registration page
     When I fill in "Login" with "cartman"
      And I fill in "Email" with "cartman@example.com"
      And I fill in "Password" with "secret"
      And I fill in "Password confirmation" with "secret"
      And I press "Create my account"
     Then I should be on the homepage
      And I should see "Thank you for registering cartman, your account has been created!"
  
  Scenario: Failing to register due to invalid parameters
    Given I am on the registration page
     When I press "Create my account"
     Then I should see "Acount registration failed!"