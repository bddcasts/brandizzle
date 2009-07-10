Feature: Dashboard
  In order to get a quick snapshot view of what is going on with my brand
  I want to see search results in a dashboard
  
  Background: 
    Given an existing brand "BDDCasts"
    And there is a search "bdd screencast" for "BDDCasts"
      
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