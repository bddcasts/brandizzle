Feature: Manage Brands
  In order keep track of what everyone is saying about my brands
  As a user
  I want to manage my brands

  Background:
    Given I am logged in as account holder "cartman"
      And a brand "Kerfluegle" exists with name: "Kerfluegle", team: team "cartman_team"

  Scenario: A user sees the dashboard
    Given I am on the brands page
     Then I should see "Kerfluegle"
  
  Scenario: Adding a new brand
    Given I am on the brands page
     When I follow "Add a new brand"
      And I fill in "Name" with "Kerfluegle"
      And I press "Create"
     Then I should see "Brand successfully created."
      And I should see "Kerfluegle"
      
  Scenario: Update a brand
    Given I am on the brands page
     When I follow "Manage" for brand "Kerfluegle"
     Then I should be on the brand edit page for "Kerfluegle"
     When I fill in "Name" with "DDDCasts"
      And I press "Update"
     Then I should see "Brand updated."
      And I should see "DDDCasts"
  
  Scenario: Delete a brand
    Given I am on the brands page
     When I follow "Remove" for brand "Kerfluegle"
     Then I should see "Brand deleted"
      And I should be on the brands page
      And I should not see "Kerfluegle"

  Scenario: Add a query
    Given I am on the brand edit page for "Kerfluegle"
     When I fill in "query_term" with "jschoolcraft"
      And I press "Add term"
     Then I should see "Added query term."
      And I should see "jschoolcraft"
  
  Scenario: Adding a query when results already exists
    Given a query "jeff" exists with term: "jschoolcraft"
      And a result "jeff-foo" exists with body: "foo"
      And a search result exists with query: query "jeff", result: result "jeff-foo"
      And I am on the brand edit page for "Kerfluegle"
     When I fill in "query_term" with "jschoolcraft"
      And I press "Add term"
      And the delayed job worker does 1 job
     Then a brand result should exist with brand: brand "Kerfluegle", result: result "jeff-foo"

  Scenario: Delete a query
    Given a query "jschoolcraft" exists with term: "jschoolcraft"
      And a brand query exists with brand: brand "Kerfluegle", query: query "jschoolcraft"
     When I am on the brand edit page for "Kerfluegle"
      And I follow "Remove" for query "jschoolcraft"
     Then I should see "Deleted query term."
      And I should not see "jschoolcraft"
            
  Scenario: Trying to add a query when account has reached search terms limit
    Given I am on the brand edit page for "Kerfluegle"
      And 10 brand_queries exist with brand: brand "Kerfluegle"
     When I fill in "query_term" with "one two many terms"
      And I press "Add term"
     Then I should be on the edit account page
      And I should see "You reached the limit of search terms. Query term not added."
      And a query should not exist with term: "one two many terms"
  