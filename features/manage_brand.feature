Feature: Manage Brands
  In order keep track of what everyone is saying about my brands
  As a user
  I want to manage my brands

  Background:
    Given an existing brand "Kerfluegle"

  Scenario: A user sees the dashboard
    Given I am on the dashboard
     Then I should see "Kerfluegle"
  
  Scenario: Adding a new brand
    Given I am on the dashboard
     When I follow "Add brand"
      And I fill in "Name" with "Kerfluegle"
      And I press "Create"
     Then I should see "Brand successfully created."
      And I should see "Kerfluegle"
      
  Scenario: Update a brand
    Given I am on the brand edit page for "Kerfluegle"
      And I fill in "Name" with "DDDCasts"
      And I press "Update"
     Then I should see "Brand updated."
      And I should see "DDDCasts"
  
  Scenario: Delete a brand
    Given I am on the brand edit page for "Kerfluegle"
      And I press "Delete"
     Then I should see "Brand deleted"
      And I should be on the dashboard
      And I should not see "Kerfluegle"
  
  Scenario: Add a search
    Given I am on the brand edit page for "Kerfluegle"
     When I fill in "search_term" with "jschoolcraft"
      And I press "Add term"
     Then I should see "Added search term."
      And I should see "jschoolcraft"
      
  Scenario: Delete a search
    Given there is a search "jschoolcraft" for "Kerfluegle"
     When I am on the brand edit page for "Kerfluegle"
      And I delete search term "jschoolcraft"
     Then I should see "Deleted search term."
      And I should not see "jschoolcraft"
  
  
    