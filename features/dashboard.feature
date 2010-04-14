Feature: Dashboard
  In order to better manage what's happening with my results and team
  As a user
  I want to view events on the dashboard

  Background:
    Given I am logged in as account holder "cartman"
  
  Scenario: Viewing the dashboard with no logs
    Given I am on the dashboard page
     Then I should see "There are no logs"
  
  Scenario: Viewing the dashboard with logs
    Given a brand_result "br" exists
    Given a log "log" exists with user: user "cartman", loggable: brand_result "br"
     When I am on the dashboard page
     Then I should see "cartman" for log "log"
  
  
  