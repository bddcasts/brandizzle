Feature: Account management
  In order to keep my account up to date
  As a registered user
  I want to manage my account information
  
  Scenario: Visiting my account
    Given I am logged in as "cartman"
      And I am on the dashboard
     When I follow "My account"
     Then I should be on my account page
      And I should see "Edit your account information"
  
  Scenario: Update password
    Given I am logged in as "cartman"
      And I am on my account page
      And I fill in "Password" with "better_secret"
      And I fill in "Password confirmation" with "better_secret"
      And I press "Update information"
     Then I should be on my account page
      And I should see "Account information updated!"
  
  Scenario: Recovering and reseting password
    Given a user exists with email: "cartman@example.com"
     When I am on the login page
      And I follow "Forgot your password?"
      And I fill in "Email" with "cartman@example.com"
      And I press "Request password reset"
     Then I should be on the homepage
      And I should see "We have sent password reset instructions to cartman@example.com. Please check your email."
      And "cartman@example.com" should receive an email
     When I open the email
     Then I should see "[Brandizzle.com] Password Reset Instructions" in the email subject
     When I click the first link in the email
      And I fill in "Password" with "secret"
      And I fill in "Password confirmation" with "secret"
      And I press "Update my password and log me in"
     Then I should be on the dashboard
      And I should see "Password successfully updated!"