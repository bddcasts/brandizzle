Feature: Manage Brands
  In order keep track of what everyone is saying about my brands
  As a user
  I want to manage my brands

  Background:
    Given an existing brand "BDDCasts"
      And I am on the dashboard

  Scenario: A user sees the dashboard
     Then I should see "BDDCasts"
  
  Scenario: Adding a new brand
     When I follow "Add brand"
      And I fill in "Name" with "BDDCasts"
      And I press "Create"
     Then I should see "Brand successfully created."
      And I should see "BDDCasts"
      
  Scenario: Update a brand
     When I follow "BDDCasts"
      And I fill in "Name" with "DDDCasts"
      And I press "Update"
     Then I should see "Brand updated."
      And I should see "DDDCasts"
  
  Scenario: Delete a brand
     When I follow "BDDCasts"
      And I press "Delete"
     Then I should see "Brand deleted"
      And I should be on the dashboard
      And I should not see "BDDCasts"
  
  
    