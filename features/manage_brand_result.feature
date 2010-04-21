Feature: Manage brand results
  In order to better follow what is going on with my brand
  I want to follow up, complete or reject results

  Background:
    Given I am logged in as account holder "cartman"
      And a brand: "BDDCasts" exists with name: "BDDCasts", team: team "cartman_team"
      And a query: "bdd screencast" exists with term: "bdd screencast"
      And a brand query exists with brand: brand "BDDCasts", query: query "bdd screencast"
      And a result "bdd" exists with source: "twitter", body: "Does anyone know any bdd screencasts?", url: "http://twitter.com/statuses/123"
  
  Scenario: Viewing a result
    Given a brand_result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_results page
     When I follow "View" for brand result "br_bdd"
     Then I should be on the brand_result "br_bdd" page
      And I should see "Does anyone know any bdd screencasts?"
  
  @javascript
  Scenario: Marking a result as follow up (also creates a log entry to be shown on the dashboard)
    Given a brand_result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_results page
     When I follow "Follow up" for brand result "br_bdd"
     Then I should be on the brand_results page
      And I should see "follow up" for brand_result "br_bdd"
      And brand result "br_bdd" should be follow_up
      And a log should exist with loggable: brand_result "br_bdd", user: user "cartman"
  
  @javascript
  Scenario: Marking a result as done (should also create a log entry to be shown on the dashboard)
    Given a follow_up_brand_result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_results page
     When I follow "Done" for brand result "br_bdd"
     Then I should be on the brand_results page
      And I should see "done" for brand_result "br_bdd"
      And brand result "br_bdd" should be done
      And a log should exist with loggable: brand_result "br_bdd", user: user "cartman"
    
  @javascript
  Scenario: Marking a result as rejected (should also create a log entry to be shown on the dashboard)
    Given a follow_up_brand_result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_results page
     When I follow "Reject" for brand result "br_bdd"
     Then I should be on the brand_results page
      And I should not see "follow up" for brand_result "br_bdd"
      And brand result "br_bdd" should be normal
      And a log should exist with loggable: brand_result "br_bdd", user: user "cartman"
  
  @javascript
  Scenario Outline: Marking a result as positive/neutral/negative (should also create a log entry to be shown on the dashoard)
    Given a brand_result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_results page
     When I follow "<action>" for brand result "br_bdd"
     Then I should be on the brand_results page
      And I should see "<action>" for brand_result "br_bdd"
      And brand result "br_bdd" should be <temperature>
      And a log should exist with loggable: brand_result "br_bdd", user: user "cartman"
  
    Examples:
      | action | temperature |
      | +      | positive    |
      | =      | neutral     |
      | -      | negative    |
  
  @javascript
  Scenario: Marking a result as read  
    Given a brand_result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_results page
     When I follow "Mark as read" for brand result "br_bdd"
     Then I should be on the brand_results page
      And I should not see "Mark as read" for brand_result "br_bdd"
      And brand result "br_bdd" should be read
  
  Scenario: Commenting on a result (should also create a log entry to be shown on the dashboard)
    Given a brand result "br_bdd" exists with brand: brand "BDDCasts", result: result "bdd"
      And I am on the brand_result "br_bdd" page
     When I fill in "Leave a comment" with "OMG they killed Kenny"
      And I press "Post comment"
     Then I should be on the brand_result "br_bdd" page
      And I should see "Comment posted"
      And I should see "OMG they killed Kenny" within ".comments"
      And I should see "cartman" within ".comments"
      And a comment "comm" should exist with user: user "cartman", brand_result: brand_result "br_bdd", content: "OMG they killed Kenny"
      And a log should exist with loggable: comment "comm", user: user "cartman"
