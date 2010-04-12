Feature: Twitter oauth
  In order to access Brandizzle with my Twitter account
  As a Twitter user
  I want to register my Twitte account and login using it
  
  Scenario: Logging in with Twitter
    Given a Twitter user "twitter_guy" registered with Brandizzle
      And I am on the login page
     When I press "Login with Twitter"
     Then I should see "Welcome twitter_guy!"
     
  Scenario: Attempting to log in an unregistered user with Twitter
   Given a Twitter user "twitter_guy" that is not registered with Brandizzle
     And I am on the login page
    When I press "Login with Twitter"
    Then I should see "Could not find user in our database"
    
  Scenario: Denying Brandizzle login access to Twitter
    Given a Twitter user that denies access to Brandizzle
     When I am on the login page
      And I press "Login with Twitter"
     Then I should see "You did not allow Brandizzle to use your Twitter account"
  
  Scenario: Authorizing Brandizzle using Twitter account
    Given I am logged in as "cartman"
      And user "cartman" has not authorized Brandizzle to user Twitter account
      And I am on my info page
     When I press "Authorize with Twitter"
     Then I should see "Account information updated!"

  Scenario: Denying Brandizzle authorize access to Twitter
   Given I am logged in as "cartman"
     And a Twitter user that denies access to Brandizzle
     And I am on my info page
    When I press "Authorize with Twitter"
    Then I should see "Account Information"