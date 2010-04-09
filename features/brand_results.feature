Feature: Results
  In order to get a quick snapshot view of what is going on with my brand
  I want to see results in a dashboard
  
  Background:
    Given I am logged in as account holder "cartman"
      And a brand: "BDDCasts" exists with name: "BDDCasts", team: team "cartman_team"
      And a query: "bdd screencast" exists with term: "bdd screencast"
      And a brand query exists with brand: brand "BDDCasts", query: query "bdd screencast"
    
  Scenario: Looking at the results page with no results
    When I am on the brand_results page
    Then I should see "No results found"
    
  Scenario: Looking at the results page with results
    Given the following results exist:
        | result | source  | body                                  | url                             | created_at        |
        | one    | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
        | two    | twitter | bdd screencasts anyone?               | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
        | three  | twitter | Awesome bdd screencast: blah blah     | http://twitter.com/statuses/789 | 09 Jul 2009 18:25 |
      And the following brand results exist:
        | brand            | result         |
        | brand "BDDCasts" | result "one"   |
        | brand "BDDCasts" | result "two"   |
        | brand "BDDCasts" | result "three" |
     When I am on the brand_results page
     Then I should see the following results:
      | content                               | created_at        |
      | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
      | bdd screencasts anyone?               | 09 Jul 2009 15:16 |
      | Awesome bdd screencast: blah blah     | 09 Jul 2009 18:25 |

  Scenario: Paginating the results
    Given 20 brand results exist with brand: brand "BDDCasts"
     When I am on the brand_results page
     Then I should see "Result #15"
      And I should not see "Result #16"
     When I follow "2" within ".pagination"
     Then I should see "Result #16"
      And I should not see "Result #15"
  
  Scenario: Filter results by brand
    Given a brand: "RadiantCasts" exists with name: "RadiantCasts", team: team "cartman_team"
      And a query: "rs" exists with term: "radiant screencasts"
      And a brand query exists with brand: brand "RadiantCasts", query: query "rs"
      And the following results exist:
        | result | source  | body                                  | url                             | created_at        |
        | one    | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
        | two    | twitter | radiant screencasts anyone?           | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
      And the following brand results exist:
        | brand                | result       |
        | brand "BDDCasts"     | result "one" |
        | brand "RadiantCasts" | result "two" |
      And I am on the brand_results page
     Then I should see the following results:
        | content                               | created_at        |
        | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
        | radiant screencasts anyone?           | 09 Jul 2009 15:16 |
     When I follow "BDDCasts" within "#brand_filters"
     Then I should see the following results:
        | content                               | created_at        |
        | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
      And I should not see "radiant screencasts anyone?"
     When I follow "RadiantCasts" within "#brand_filters"
     Then I should see the following results:
        | content                     | created_at        |
        | radiant screencasts anyone? | 09 Jul 2009 15:16 |
      And I should not see "Does anyone know any bdd screencasts?"
      
  Scenario: Filter results by brand_result state
    Given the following results exist:
        | result | source  | body                                  | url                             | created_at        |
        | one    | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
        | two    | twitter | radiant screencasts anyone?           | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
      And the following brand results exist:
        | brand            | result       | state     |
        | brand "BDDCasts" | result "one" | follow_up |
        | brand "BDDCasts" | result "two" | done      |
      And I am on the brand_results page
     Then I should see the following results:
        | content                               | created_at        |
        | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
        | radiant screencasts anyone?           | 09 Jul 2009 15:16 |
     When I follow "Follow up" within "#state_filters"
     Then I should see the following results:
        | content                               | created_at        |
        | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
      And I should not see "radiant screencasts anyone?"
     When I follow "Done" within "#state_filters"
     Then I should see the following results:
        | content                     | created_at        |
        | radiant screencasts anyone? | 09 Jul 2009 15:16 |
      And I should not see "Does anyone know any bdd screencasts?"
  
  Scenario: Filtering results by date range
      Given the following results exist:
          | result | source  | body                                  | url                             | created_at        |
          | one    | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 08 Jul 2010 13:28 |
          | two    | twitter | radiant screencasts anyone?           | http://twitter.com/statuses/456 | 09 Jul 2010 15:16 |
        And the following brand results exist:
          | brand            | result         |
          | brand "BDDCasts" | result "one"   |
          | brand "BDDCasts" | result "two"   |
       And I am on the brand_results page          
      When I fill in "between_date" with "Jul 9, 2010" within ".sidebar"
       And I press "GO" within ".sidebar"
      Then I should see the following results:
          | content                     | created_at        |
          | radiant screencasts anyone? | 09 Jul 2009 15:16 |
       And I should not see "Does anyone know any bdd screencasts?"
       
       
       
       
       
       
       
       