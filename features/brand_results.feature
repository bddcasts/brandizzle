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
        | brand            | result         | team                |
        | brand "BDDCasts" | result "one"   | team "cartman_team" |
        | brand "BDDCasts" | result "two"   | team "cartman_team" |
        | brand "BDDCasts" | result "three" | team "cartman_team" |
     When I am on the brand_results page
     Then I should see the following results:
        | content                               | created_at        |
        | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
        | bdd screencasts anyone?               | 09 Jul 2009 15:16 |
        | Awesome bdd screencast: blah blah     | 09 Jul 2009 18:25 |
  
  Scenario: Looking at the results page, I should not see read results
    Given the following results exist:
        | result | source  | body                                  | url                             | created_at        |
        | one    | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
        | two    | twitter | bdd screencasts anyone?               | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
        | three  | twitter | Awesome bdd screencast: blah blah     | http://twitter.com/statuses/789 | 09 Jul 2009 18:25 |
      And the following brand results exist:
        | brand            | result         | read  | team                |
        | brand "BDDCasts" | result "one"   | false | team "cartman_team" |
        | brand "BDDCasts" | result "two"   | false | team "cartman_team" |
        | brand "BDDCasts" | result "three" | true  | team "cartman_team" |
     When I follow "Results" within ".navigation"
     Then I should see the following results:
        | content                               | created_at        |
        | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
        | bdd screencasts anyone?               | 09 Jul 2009 15:16 |
      And I should not see "Awesome bdd screencast: blah blah"

  Scenario: Paginating the results
    Given 20 brand results exist with brand: brand "BDDCasts", team: team "cartman_team"
     When I am on the brand_results page
     Then current page for ".results" should be 1
     When I follow "2" within ".pagination"
     Then current page for ".results" should be 2
  
  Scenario: Filter results by brand
    Given a brand: "RadiantCasts" exists with name: "RadiantCasts", team: team "cartman_team"
      And a query: "rs" exists with term: "radiant screencasts"
      And a brand query exists with brand: brand "RadiantCasts", query: query "rs"
      And the following results exist:
        | result | source  | body                                  | url                             | created_at        |
        | one    | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
        | two    | twitter | radiant screencasts anyone?           | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
      And the following brand results exist:
        | brand                | result       | team                |
        | brand "BDDCasts"     | result "one" | team "cartman_team" |
        | brand "RadiantCasts" | result "two" | team "cartman_team" |
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
        | brand            | result       | state     | read | team                |
        | brand "BDDCasts" | result "one" | follow_up | true | team "cartman_team" |
        | brand "BDDCasts" | result "two" | done      | true | team "cartman_team" |
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
          | brand            | result       | team                |
          | brand "BDDCasts" | result "one" | team "cartman_team" |
          | brand "BDDCasts" | result "two" | team "cartman_team" |
       And I am on the brand_results page          
      When I fill in "between_date" with "Jul 9, 2010" within ".sidebar"
       And I press "GO" within ".sidebar"
      Then I should see the following results:
          | content                     | created_at        |
          | radiant screencasts anyone? | 09 Jul 2009 15:16 |
       And I should not see "Does anyone know any bdd screencasts?"
  
  Scenario: Filtering results by read state
    Given the following results exist:
          | result | source  | body                                  | url                             | created_at        |
          | one    | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 08 Jul 2010 13:28 |
          | two    | twitter | radiant screencasts anyone?           | http://twitter.com/statuses/456 | 09 Jul 2010 15:16 |
      And the following brand results exist:
          | brand            | result       | read  | team                |
          | brand "BDDCasts" | result "one" | true  | team "cartman_team" |
          | brand "BDDCasts" | result "two" | false | team "cartman_team" |
      And I am on the brand_results page
     Then I should see the following results:
          | content                               | created_at        |
          | Does anyone know any bdd screencasts? | 09 Jul 2009 13:28 |
          | radiant screencasts anyone?           | 09 Jul 2009 15:16 |
     When I follow "Unread" within "#state_filters"
     Then I should see "radiant screencasts anyone?"
      And I should not see "Does anyone know any bdd screencasts?"

     When I follow "Read" within "#state_filters"
     Then I should see "Does anyone know any bdd screencasts?"
      And I should not see "radiant screencasts anyone?"

  Scenario: Marking all results as read
    Given the following results exist:
        | result | source  | body                                  | url                             | created_at        |
        | one    | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
        | two    | twitter | radiant screencasts anyone?           | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
      And the following brand_results exist:
        | brand_result | brand            | result       | state     | team                |
        | first        | brand "BDDCasts" | result "one" | follow_up | team "cartman_team" |
        | second       | brand "BDDCasts" | result "two" | done      | team "cartman_team" |
      And I follow "Results" within ".navigation"
  
     When I follow "Mark them as read" within ".top"
     Then I should see "No results found"
      And brand_result "first" should be read
      And brand_result "second" should be read
    
  Scenario: Marking results filtered by brand as read
    Given a brand: "RadiantCasts" exists with name: "RadiantCasts", team: team "cartman_team"
      And a query: "rs" exists with term: "radiant screencasts"
      And a brand query exists with brand: brand "RadiantCasts", query: query "rs"
      And the following results exist:
        | result | source  | body                                  | url                             | created_at        |
        | one    | twitter | Does anyone know any bdd screencasts? | http://twitter.com/statuses/123 | 09 Jul 2009 13:28 |
        | two    | twitter | radiant screencasts anyone?           | http://twitter.com/statuses/456 | 09 Jul 2009 15:16 |
      And the following brand_results exist:
        | brand_result | brand                | result       | team                |
        | first        | brand "BDDCasts"     | result "one" | team "cartman_team" |
        | second       | brand "RadiantCasts" | result "two" | team "cartman_team" |
      And I follow "Results" within ".navigation"
      And I follow "BDDCasts" within "#brand_filters"
     
     When I follow "Mark them as read" within ".top"
     Then brand_result "first" should be read
      And brand_result "second" should not be read
