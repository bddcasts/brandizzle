Feature: Results
  In order to get a quick snapshot view of what is going on with my brand
  I want to see results in a dashboard
  
  Background:
    Given I am logged in as account holder "cartman"
      And a brand: "BDDCasts" exists with name: "BDDCasts", team: team "cartman_team"
      And a query: "bdd screencast" exists with term: "bdd screencast"
      And a brand query exists with brand: brand "BDDCasts", query: query "bdd screencast"
      
  Scenario: Looking at the results page with no results
    When I am on the results page
    Then I should see "No results found"
  
  Scenario: Looking at the results page with results
    Given query: "bdd screencast" has the following results for brand: "BDDCasts":
      | source  | body                                  | url                             | created_at        |
      | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
      | twitter | bdd screencasts anyone?               | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
      | twitter | Awesome bdd screencast: blah blah     | http://twitter.com/statuses/789 | 09 Jul 2009 18:25 |
    When I am on the results page
    Then I should see the following results:
      | message                               | created_at        |
      | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
      | bdd screencasts anyone?               | 09 Jul 2009 15:16 |
      | Awesome bdd screencast: blah blah     | 09 Jul 2009 18:25 |
        
  Scenario: Paginating results
    Given query: "bdd screencast" has 20 results for brand: "BDDCasts"
     When I am on the results page
     Then I should see "Result #1"
      And I should see "Result #15"
      And I should not see "Result #16"
     When I follow "2"
     Then I should see "Result #16"
      And I should not see "Result #15"
  
  Scenario: Filter results by Brand
    Given a brand: "Bar" exists with name: "Bar", team: team "cartman_team"
      And a query: "foo" exists with term: "foo"
      And a brand query exists with brand: brand "Bar", query: query "foo"
      And query: "bdd screencast" has the following results for brand: "BDDCasts":
        | source  | body                                  | url                             | created_at        |
        | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
      And query: "foo" has the following results for brand: "Bar":
        | source  | body                                       | url                             | created_at        |
        | twitter | Isn't foo the awesomest variable name evar | http://twitter.com/statuses/789 | 09 Jul 2009 18:25 |
      And I am on the results page
     When I follow "BDDCasts" within ".sidebar"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "Isn't foo the awesomest variable name evar"
  
  Scenario: Filter results results by state
    Given query: "bdd screencast" has the following results for brand: "BDDCasts":
        | source  | body                                  | url                             | created_at        | state     |
        | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 | follow_up |
        | blog    | This blog is teh stuff                | http://twitter.com/statuses/456 | 09 Jul 2009 13:28 | done      |
      And I am on the results page
     When I follow "Follow up" within ".heading"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "This blog is teh stuff"
    
     When I follow "Done" within ".heading"
     Then I should not see "Does anyone know any bdd screencasts?"
      And I should see "This blog is teh stuff"
  
  @wip
  Scenario: Filter results by date range
    Given query: "bdd screencast" has the following results for brand: "BDDCasts":
        | source  | body                                  | url                             | created_at        |
        | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | Time.now |
        | blog    | This blog is teh stuff                | http://twitter.com/statuses/456 | 1.days.from_now |
      And I am on the results page
     When I follow "Today" within ".sidebar"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "This blog is teh stuff"
  