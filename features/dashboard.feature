Feature: Dashboard
  In order to get a quick snapshot view of what is going on with my brand
  I want to see results in a dashboard
  
  Background: 
    Given I am logged in as "cartman"
      And a brand: "BDDCasts" exists with name: "BDDCasts", user: user "cartman"
      And a query: "bdd screencast" exists with term: "bdd screencast"
      And a brand query exists with brand: brand "BDDCasts", query: query "bdd screencast"
      
  Scenario: Looking at the dashboard with no results
    When I am on the dashboard
    Then I should see "No results."
  
  Scenario: Looking at the dashboard with results
    Given query: "bdd screencast" has the following results for brand: "BDDCasts":
      | source  | body                                  | url                             | created_at        |
      | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
      | twitter | bdd screencasts anyone?               | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
      | twitter | Awesome bdd screencast: blah blah     | http://twitter.com/statuses/789 | 09 Jul 2009 18:25 |
    When I am on the dashboard
    Then I should see the following results:
      | message                               | created_at        |
      | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
      | bdd screencasts anyone?               | 09 Jul 2009 15:16 |
      | Awesome bdd screencast: blah blah     | 09 Jul 2009 18:25 |
        
  Scenario: Paginating results
    Given query: "bdd screencast" has 20 results for brand: "BDDCasts"
     When I am on the dashboard
     Then I should see "Result #1"
      And I should see "Result #15"
      And I should not see "Result #16"
     When I follow "2"
     Then I should see "Result #16"
      And I should not see "Result #15"
  
  @javascript
  Scenario: Filter dashboard results by Brand
    Given a brand: "Bar" exists with name: "Bar", user: user "cartman"
      And a query: "foo" exists with term: "foo"
      And a brand query exists with brand: brand "Bar", query: query "foo"
      And query: "bdd screencast" has the following results for brand: "BDDCasts":
        | source  | body                                  | url                             | created_at        |
        | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
      And query: "foo" has the following results for brand: "Bar":
        | source  | body                                       | url                             | created_at        |
        | twitter | Isn't foo the awesomest variable name evar | http://twitter.com/statuses/789 | 09 Jul 2009 18:25 |
      And I am on the dashboard
     When I select "BDDCasts" from "Brand"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "Isn't foo the awesomest variable name evar"
      
  @javascript
  Scenario: Filter dashboard results by Source
    Given query: "bdd screencast" has the following results for brand: "BDDCasts":
        | source  | body                                  | url                             | created_at        |
        | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
        | blog    | This blog is teh stuff                | http://twitter.com/statuses/456 | 09 Jul 2009 13:28 |
      And I am on the dashboard
     When I select "twitter" from "Source"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "This blog is teh stuff"
  
  @javascript
  Scenario: Mark a result for follow up
    Given query "bdd screencast" has 1 results for brand: "BDDCasts"
      And I am on the dashboard
     When I press "Follow up"
     Then I should be on the dashboard
     When I press "Done"
     Then I should be on the dashboard
  
  @javascript
  Scenario: Filter dashboard results by follow up  
    Given query: "bdd screencast" has the following results for brand: "BDDCasts":
        | source  | body                                  | url                             | created_at        | follow_up |
        | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 | true      |
        | blog    | This blog is teh stuff                | http://twitter.com/statuses/456 | 09 Jul 2009 13:28 |           |
      And I am on the dashboard
     When I select "follow up" from "Flag"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "This blog is teh stuff"
  