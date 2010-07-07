Feature: Dashboard
  In order to better manage what's happening with my results and team
  As a user
  I want to view events on the dashboard

  Background:
    Given I am logged in as account holder "cartman"
  
  Scenario: Viewing the dashboard with no records
    Given I am on the dashboard page
     Then I should see "There are no logs."
      And I should see "There are no results to follow up."
      And I should see "There are no comments."
  
  Scenario Outline: Viewing a follow_up/rejected/done brand_result log on the dashboard
    Given a result "foo" exists with body: "<body>"
      And a <state>_brand_result "br" exists with state: "<state>", result: result "foo"
      And a <state>_brand_result_log "log" exists with user: user "cartman", team: team "cartman_team", loggable: <state>_brand_result "br"
     When I am on the dashboard page
     Then I should see "<status>" for log "log"
      And I should see "cartman marked <body> as <content>" for log "log"
      
    Examples:
      | state     | status    | content   | body   |
      | normal    | Rejected  | rejected  | first  |
      | follow_up | Follow up | follow up | second |
      | done      | Done      | done      | third  |
  
  Scenario Outline: Viewing a positive/neutral/negative brand_result log on the dashboard
    Given a result "foo" exists with body: "<body>"
      And a <temperature>_brand_result "br" exists with temperature: <value>, result: result "foo"
      And a <temperature>_brand_result_log "log" exists with user: user "cartman", team: team "cartman_team", loggable: <temperature>_brand_result "br"
     When I am on the dashboard page
     Then I should see "<status>" for log "log"
      And I should see "cartman marked <body> as <content>" for log "log"
    
    Examples:
      | temperature | value | status   | content  | body   |
      | positive    | 1     | Positive | positive | first  |
      | neutral     | 0     | Neutral  | neutral  | second |
      | negative    | -1    | Negative | negative | third  |
  
  Scenario: Viewing a comment log on the dashboard
    Given a comment "comm" exists with user: user "cartman"
      And a comment log "log" exists with user: user "cartman", team: team "cartman_team", loggable: comment "comm"
     When I am on the dashboard page
     Then I should see "Comment" for log "log"
      And I should see "cartman" for log "log"
      
  Scenario: Paginating the logs
    Given a positive brand result "foo" exists
      And 20 follow_up_brand_result_logs exist with user: user "cartman", team: team "cartman_team", loggable: brand result "foo"
      And I am on the dashboard page
     Then current page for ".logs" should be 1
     When I follow "2" within ".pagination"
     Then current page for ".logs" should be 2
  
  Scenario: Viewing latest follow up brand results
    Given a result "r" exists with body: "Oh, my God! They killed Kenny."
      And a follow_up_brand_result exists with team: team "cartman_team", result: result "r"
     When I am on the dashboard page
     Then I should see "Oh, my God! They killed Kenny." within ".results"
  
  Scenario: Viewing latest follow up brand result when more then 15
    Given 20 follow_up_brand_results exist with team: team "cartman_team"
     When I am on the dashboard page
     Then I should see "View all follow up results" within ".results"
  
  Scenario: Viewing latest comments
    Given a comment exists with content: "Respect My Authority!", user: user "cartman"
      And I am on the dashboard page
     Then I should see "Respect My Authority!" within ".comments"
  