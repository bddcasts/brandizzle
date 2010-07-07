Feature: User Accounts
  In order to manage my brands and search terms
  As a user
  I want to register for an account, login and logout
  
  Scenario: Registering for a new account
    Given I am on the registration page
     When I fill in "Login" with "cartman"
      And I fill in "Email" with "cartman@example.com"
      And I press "Create my account"
     Then I should be on the login page
      And I should see "Your account has been created. Please check your e-mail"
      And a user "cartman" should exist with login: "cartman", email: "cartman@example.com"
      And an account "cartman_account" should exist with user: user "cartman", customer_id: "42"
      And user: "cartman" should not be active
    
     Then "cartman@example.com" should receive an email
     When I open the email
     Then I should see "[BrandPulse] Activation Instructions" in the email subject
     When I click the first link in the email
      And I fill in "Password" with "secret"
      And I fill in "Password confirmation" with "secret"
      And I check "I agree to the terms of service."
      And I press "Activate my account and log me in"
     Then I should be on the homepage
      And I should see "Welcome cartman!"
      And user: "cartman" should be active
    
  Scenario: Logging in successfully as account holder
    Given a team "t" exists
      And a user "u" exists with login: "Cartman", password: "secret", team: team "t"
      And an account "a" exists with holder: user "u", team: team "t"
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
    Given a team "t" exists
      And a user "u" exists with email: "cartman@example.com", team: team "t"
      And an account "a" exists with holder: user "u", team: team "t"
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