Feature: Teaching Offer Memberships
  As a learner or tutor
  I want to manage memberships
  So that learners can apply and tutors can approve or reject

  Background:
    Given a user exists with name "Tutor User" and email "tutor@tamu.edu" and password "Passw0rd!"
    And a user exists with name "Learner User" and email "learner@tamu.edu" and password "Passw0rd!"
    And a teaching offer exists with title "Ruby Basics" and description "Intro" and author email "tutor@tamu.edu" and studentcap 2

  Scenario: Learner applies to join a teaching offer
    Given I am logged in as "learner@tamu.edu" with password "Passw0rd!"
    When I visit the show page for the teaching offer "Ruby Basics"
    And I press "Request to Join"
    Then I should see "Join request sent!"
    And a membership should exist for "learner@tamu.edu" in "Ruby Basics" with status "pending"
    And a notification should be sent to "tutor@tamu.edu" saying "has requested to join"

  Scenario: Learner cancels their request
    Given "learner@tamu.edu" has a pending membership in "Ruby Basics"
    And I am logged in as "learner@tamu.edu" with password "Passw0rd!"
    When I visit the show page for the teaching offer "Ruby Basics"
    And I press "Cancel Request"
    Then I should see "You left this teachingoffer."
    And no membership should exist for "learner@tamu.edu" in "Ruby Basics"
    And a notification should be sent to "tutor@tamu.edu" saying "has left your"

  Scenario: Learner leaves after approval
    Given "learner@tamu.edu" has an approved membership in "Ruby Basics"
    And I am logged in as "learner@tamu.edu" with password "Passw0rd!"
    When I visit the show page for the teaching offer "Ruby Basics"
    And I press "Leave"
    Then I should see "You left this teachingoffer."
    And no membership should exist for "learner@tamu.edu" in "Ruby Basics"
    And a notification should be sent to "tutor@tamu.edu" saying "has left your"

  Scenario: Tutor approves a learner
    Given "learner@tamu.edu" has a pending membership in "Ruby Basics"
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    When I visit the show page for the teaching offer "Ruby Basics"
    And I press "Approve" next to "Learner User"
    Then I should see "has been approved."
    And a notification should be sent to "learner@tamu.edu" saying "approved"

  Scenario: Tutor rejects a learner
    Given "learner@tamu.edu" has a pending membership in "Ruby Basics"
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    When I visit the show page for the teaching offer "Ruby Basics"
    And I press "Reject" next to "Learner User"
    Then I should see "has been rejected."
    And a notification should be sent to "learner@tamu.edu" saying "rejected"
