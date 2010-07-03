Feature: Dashboard
  In order to better manage what's happening with my results and team
  As a user
  I want to view events on the dashboard

  Background:
    Given I am logged in as account holder "cartman"
  
  Scenario: Viewing the dashboard with no logs
    Given I am on the dashboard page
     Then I should see "There are no logs"
  
  Scenario Outline: Viewing a follow_up/rejected/done brand_result log on the dashboard
    Given a result "foo" exists with body: "<body>"
      And a <state>_brand_result "br" exists with state: "<state>", result: result "foo"
      And a <state>_brand_result_log "log" exists with user: user "cartman", loggable: <state>_brand_result "br"
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
      And a <temperature>_brand_result_log "log" exists with user: user "cartman", loggable: <temperature>_brand_result "br"
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
      And a comment log "log" exists with user: user "cartman", loggable: comment "comm"
     When I am on the dashboard page
     Then I should see "Comment" for log "log"
      And I should see "cartman" for log "log"
      
  Scenario: Paginating the logs
    Given a positive brand result "foo" exists
      And 20 follow_up_brand_result_logs exist with user: user "cartman", loggable: brand result "foo"
      And I am on the dashboard page
     Then current page for ".logs" should be 1
     When I follow "2" within ".pagination"
     Then current page for ".logs" should be 2
