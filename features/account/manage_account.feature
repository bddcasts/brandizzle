Feature: User Accounts
  In order to manage my brands and search terms
  As a user
  I want to register for an account, login and logout
  
  Scenario: Registering for a new account
    Given I am on the registration page
     When I fill in "Login" with "cartman"
      And I fill in "Email" with "cartman@example.com"
      And I fill in "Password" with "secret"
      And I fill in "Password confirmation" with "secret"
      And I press "Create my account"
     Then I should be on the brand_results page
      And I should see "Your account has been created."
  
  Scenario: Visiting the login page
    Given I am on the homepage
     When I follow "Login"
     Then I should be on the login page
      And I should see "Login"
  
  Scenario: Logging in successfully
    Given a user exists with login: "Cartman", password: "secret"
      And I am on the login page
      And I fill in "Login" with "Cartman"
      And I fill in "Password" with "secret"
      And I press "Login"
     Then I should be on the brand_results page
      And I should see "Welcome Cartman"
  
  Scenario: Failing to log in
    Given I am on the login page
      And I fill in "Login" with "Cartman"
      And I fill in "Password" with "secret"
      And I press "Login"
     Then I should see "is not valid"
  
  Scenario: Recovering and reseting password
    Given a user exists with email: "cartman@example.com"
     When I am on the login page
      And I follow "Forgot your password?"
      And I fill in "Email" with "cartman@example.com"
      And I press "Request password reset"
     Then I should be on the login page
      And I should see "We have sent password reset instructions to cartman@example.com. Please check your email."
      And "cartman@example.com" should receive an email
     When I open the email
     Then I should see "[BrandPulse] Password Reset Instructions" in the email subject
     When I click the first link in the email
      And I fill in "Password" with "secret"
      And I fill in "Password confirmation" with "secret"
      And I press "Update my password and log me in"
     Then I should be on the brand_results page
      And I should see "Password successfully updated!"
  
  Scenario: Logging out
    Given I am logged in as "cartman"
      And I am on the brand_results page
     When I follow "Sign out"
     Then I should be on the login page
      And I should see "Logout successful!"

  Scenario: Updating my password
    Given I am logged in as "cartman"
      And I am on the homepage
     When I follow "My info"
      And I fill in "Password" with "better_secret"
      And I fill in "Password confirmation" with "better_secret"
      And I press "Update information"
     Then I should be on my info page
      And I should see "Account information updated!"