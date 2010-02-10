Feature: User Accounts
  In order to manage my brands and search terms
  As a user
  I want to register for an account, login and logout
  
  # Scenario: Visiting the registration page
  #   Given I am on the homepage
  #    When I follow "Sign up"
  #    Then I should be on the registration page
  #     And I should see "Register for an account"
  # 
  # Scenario: Registering for a new account and activating your account
  #   Given I am on the registration page
  #    When I fill in "Login" with "cartman"
  #     And I fill in "Email" with "cartman@example.com"
  #     And I fill in "Password" with "secret"
  #     And I fill in "Password confirmation" with "secret"
  #     And I press "Create my account"
  #    Then I should be on the login page
  #     And I should see "Your account has been created. Please check your e-mail for your account activation instructions!"
  #     And "cartman@example.com" should receive an email
  #    When I open the email
  #    Then I should see "[Brandizzle.com] Activation Instructions" in the email subject
  #     And a clear email queue
  #    When I click the first link in the email
  #    Then I should be on the dashboard
  #     And I should see "Welcome cartman! Your account has been activated!"      
  #     And "cartman@example.com" should receive an email
  #    When I open the email
  #    Then I should see "[Brandizzle.com] Activation Complete" in the email subject
  # 
  # Scenario: Failing to register due to invalid parameters
  #   Given I am on the registration page
  #    When I press "Create my account"
  #    Then I should see "Acount registration failed!"
  
  Scenario: Registering for a new account with invitation
    Given an invitation: "inv" exists with recipient_email: "cartman@example.com"
      And I am on the registration page
     When I fill in "Login" with "cartman"
      And I fill in "Password" with "secret"
      And I fill in "Password confirmation" with "secret"
      And I press "Create my account"
     Then I should be on the dashboard
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
     Then I should be on the dashboard
      And I should see "Welcome Cartman"
  
  Scenario: Failing to log in
    Given I am on the login page
      And I fill in "Login" with "Cartman"
      And I fill in "Password" with "secret"
      And I press "Login"
     Then I should see "is not valid"
     
  @javascript
  Scenario: Logging out
    Given I am logged in as "cartman"
      And I am on the dashboard
     When I follow "Sign out"
     Then I should be on the login page
      And I should see "Logout successful!"
