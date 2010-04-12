Feature: Manage brand results
  In order to better follow what is going on with my brand
  I want to follow up, complete or reject results

  Background:
    Given I am logged in as account holder "cartman"
      And a brand: "BDDCasts" exists with name: "BDDCasts", team: team "cartman_team"
      And a query: "bdd screencast" exists with term: "bdd screencast"
      And a brand query exists with brand: brand "BDDCasts", query: query "bdd screencast"
      And a result "bdd" exists with source: "twitter", body: "Does anyone know any bdd screencasts?", url: "http://twitter.com/statuses/123"
  
  @javascript
  Scenario: Marking a result as follow up
    Given a brand_result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_results page
     When I follow "Follow up" for brand result "br_bdd"
     Then I should be on the brand_results page
      And I should see "follow up" for brand_result "br_bdd"
      And brand result "br_bdd" should be follow_up
  
  @javascript
  Scenario: Marking a result as done
    Given a follow_up_brand_result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_results page
     When I follow "Done" for brand result "br_bdd"
     Then I should be on the brand_results page
      And I should see "done" for brand_result "br_bdd"
      And brand result "br_bdd" should be done
    
  @javascript
  Scenario: Marking a result as done
    Given a follow_up_brand_result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_results page
     When I follow "Reject" for brand result "br_bdd"
     Then I should be on the brand_results page
      And brand result "br_bdd" should be normal
      