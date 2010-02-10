Feature: Invite friends
  In order to
  As a user
  I want to invite my friends
  
  Scenario: Sending beta invitations
    Given I am logged in as "cartman"
      And "cartman" has invitations to send
      And I am on the dashboard
     When I follow "Invite your friends"
      And I fill in "Friend's email address" with "stan@example.com"
      And I press "Invite!"
     Then I should be on the dashboard
      And I should see "Thank you, invitation sent."
  
  Scenario: Sending invitation to an already registered user
    Given a user exists with email: "stan@example.com"
      And I am logged in as "cartman"
      And "cartman" has invitations to send
      And I am on the dashboard
     When I follow "Invite your friends"
      And I fill in "Friend's email address" with "stan@example.com"
      And I press "Invite!"
     Then I should see "is already registered"
    