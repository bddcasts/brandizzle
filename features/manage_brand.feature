Feature: Manage Brands
  In order keep track of what everyone is saying about my brands
  As a user
  I want to manage my brands

  Scenario: A user sees the dashboard
    Given an existing brand "BDDCasts"
    When I am on the dashboard
    Then I should see "BDDCasts"
  
  
  
