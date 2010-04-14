Feature: Dashboard
  In order to better manage what's happening with my results and team
  As a user
  I want to view events on the dashboard

  Background:
    Given I am logged in as account holder "cartman"
  
  Scenario: Viewing the dashboard with no logs
    Given I am on the dashboard page
     Then I should see "There are no logs"
  
  Scenario: Viewing a brand_result log on the dashboard
    Given a brand_result "br" exists with state: "follow_up"
      And a log "log" exists with user: user "cartman", loggable: brand_result "br"
     When I am on the dashboard page
     Then I should see "Result" for log "log"
      And I should see "cartman" for log "log"
      And I should see "follow up" for log "log"
  
  Scenario: Viewing a comment log on the dashboard
    Given a comment "comm" exists with user: user "cartman"
      And a log "log" exists with user: user "cartman", loggable: comment "comm"
     When I am on the dashboard page
     Then I should see "Comment" for log "log"
      And I should see "cartman" for log "log"
      
  Scenario: Paginating the logs
    Given 20 brand_result_logs exist with user: user "cartman"
      And I am on the dashboard page
     Then current page for ".logs" should be 1
     When I follow "2" within ".pagination"
     Then current page for ".logs" should be 2