Feature: Twitter oauth
  In order to access Brandizzle with my Twitter account
  As a Twitter user
  I want to register my Twitte account and login using it
  
  Scenario: Authorizing my Twitter account
    Given I am logged in as "cartman"
      And I am on the user edit page for "cartman"
     When I press "Authorize with Twitter"
     Then I should see "Account information updated!"