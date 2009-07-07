Feature: Manage Brands
  In order keep track of what everyone is saying about my brands
  As a user
  I want to manage my brands

  Scenario: A user sees the dashboard
    Given an existing brand "BDDCasts"
     When I am on the dashboard
     Then I should see "BDDCasts"
  
  Scenario: Adding a new brand
    Given I am on the dashboard
     When I follow "Add brand"
      And I fill in "Name" with "BDDCasts"
      And I press "Create"
     Then I should see "Brand successfully created."
      And I should see "BDDCasts"
    