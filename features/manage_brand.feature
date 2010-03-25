Feature: Manage Brands
  In order keep track of what everyone is saying about my brands
  As a user
  I want to manage my brands

  Background:
    Given I am logged in as "cartman"
      And a brand: "Kerfluegle" exists with name: "Kerfluegle", user: user "cartman"

  Scenario: A user sees the dashboard
    Given I am on the brands index page
     Then I should see "Kerfluegle"
  
  Scenario: Adding a new brand
    Given I am on the brands index page
     When I follow "Add a new brand"
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
      And I press "Delete brand"
     Then I should see "Brand deleted"
      And I should be on the brands index page
      And I should not see "Kerfluegle"
  
  Scenario: Add a query
    Given I am on the brand edit page for "Kerfluegle"
     When I fill in "query_term" with "jschoolcraft"
      And I press "Add term"
     Then I should see "Added query term."
      And I should see "jschoolcraft"

  # @javascript
  # Scenario: Delete a query
  #   Given a query "jschoolcraft" exists with term: "jschoolcraft"
  #     And a brand query exists with brand: brand "Kerfluegle", query: query "jschoolcraft"
  #    When I am on the brand edit page for "Kerfluegle"
  #     And I follow "Remove"
  #    Then I should see "Deleted query term."
  #     And I should not see "jschoolcraft"
