Feature: Notifications
  As a user
  I want to view my notifications and control email alerts
  So that I can stay informed about teaching offers

  Background:
    Given a user exists with name "Tutor User" and email "tutor@tamu.edu" and password "Passw0rd!"
    And a user exists with name "Learner User" and email "learner@tamu.edu" and password "Passw0rd!"
    And a teaching offer exists with title "Ruby Basics" and description "Intro" and author email "tutor@tamu.edu" and studentcap 2

  Scenario: Tutor sees notifications on their dashboard
    Given "learner@tamu.edu" has a pending membership in "Ruby Basics"
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    When I visit the notifications page
    Then I should see "Learner User has requested to join your teaching offer."

  Scenario: Email notification is sent when user has email notifications enabled
    Given I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    And email notifications are enabled for "tutor@tamu.edu"
    When a notification is created for "tutor@tamu.edu" with message "Test email notification" and url "/teaching_offers/1"
    Then an email should have been sent to "tutor@tamu.edu" with subject "New Notification from BulletinApp"
    And the email body should contain "Test email notification"
    And the email body should contain "View on Bulletin"

  Scenario: Email notification is NOT sent when disabled
    Given I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    And email notifications are disabled for "tutor@tamu.edu"
    When a notification is created for "tutor@tamu.edu" with message "Silent notification" and url "/teaching_offers/1"
    Then no email should have been sent to "tutor@tamu.edu"

  Scenario: User toggles email notification preference
    Given I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    And email notifications are disabled for "tutor@tamu.edu"
    When I visit the notifications page
    And I check "Receive email notifications"
    And I press "Update"
    Then I should see "Email Notifications: Enabled"
    And email notifications should be enabled for "tutor@tamu.edu"
