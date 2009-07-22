Feature: Dashboard
  In order to get a quick snapshot view of what is going on with my brand
  I want to see search results in a dashboard
  
  Background: 
    Given there is a search "bdd screencast" for "BDDCasts"
      
  Scenario: Looking at the dashboard with search results
    Given "bdd screencast" has the following search results:
      | source  | body                                  | url                             | created_at        |
      | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
      | twitter | bdd screencasts anyone?               | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
      | twitter | Awesome bdd screencast: blah blah     | http://twitter.com/statuses/789 | 09 Jul 2009 18:25 |
    When I am on the dashboard
    Then I should see the following search results:
      | message                               | created_at        |
      | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
      | bdd screencasts anyone?               | 09 Jul 2009 15:16 |
      | Awesome bdd screencast: blah blah     | 09 Jul 2009 18:25 |
      
  Scenario: Looking at the dashboard with no search results
    When I am on the dashboard
    Then I should see "No results."
  
  Scenario: Paginating search results
    Given "bdd screencast" has 20 search results
     When I am on the dashboard
     Then I should see "Search result #1"
      And I should see "Search result #15"
      And I should not see "Search result #16"
     When I follow "2"
     Then I should see "Search result #16"
      And I should not see "Search result #15"
  
  Scenario: Filter dashboard results by Brand
    Given there is a search "foo" for "Bar"
      And "bdd screencast" has the following search results:
        | source  | body                                  | url                             | created_at        |
        | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
      And "foo" has the following search results:
        | source  | body                                       | url                             | created_at        |
        | twitter | Isn't foo the awesomest variable name evar | http://twitter.com/statuses/789 | 09 Jul 2009 18:25 |
      And I am on the dashboard
     When I select "BDDCasts" from "Brand"
      And I press "Filter"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "Isn't foo the awesomest variable name evar"

  Scenario: Filter dashboard results by Source
    Given "bdd screencast" has the following search results:
        | source  | body                                  | url                             | created_at        |
        | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
        | blog    | This blog is teh stuff                | http://twitter.com/statuses/456 | 09 Jul 2009 13:28 |
      And I am on the dashboard
     When I select "twitter" from "Source"
      And I press "Filter"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "This blog is teh stuff"
  
  Scenario: Mark a search result for follow up
    Given "bdd screencast" has 1 search results
      And I am on the dashboard
     When I press "Follow Up" 
     Then I should be on the dashboard
     When I press "Done"
     Then I should be on the dashboard
  
  Scenario: Filter dashboard results by follow up  
    Given "bdd screencast" has the following search results:
        | source  | body                                  | url                             | created_at        | follow_up |
        | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 | true      |
        | blog    | This blog is teh stuff                | http://twitter.com/statuses/456 | 09 Jul 2009 13:28 |           |
      And I am on the dashboard
     When I select "follow up" from "Flag"
      And I press "Filter"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "This blog is teh stuff"
  