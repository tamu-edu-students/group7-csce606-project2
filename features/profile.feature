Feature: Viewing a user profile
  As a registered user
  I want to view a user’s profile
  So that I can see their projects, teaching offers, and posts

  Background:
    Given a user exists with name "Tutor User" and email "tutor@tamu.edu" and password "Passw0rd!"
    Given a user exists with name "Other User" and email "other@tamu.edu" and password "Passw0rd!"
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"

  Scenario: User visits their own profile
    When I visit my profile page
    Then I should see my name
    And I should see the "Created Projects" tab
    And I should see the "Joined Projects" tab
    And I should see the "Teacher" tab
    And I should see the "Student" tab
    And I should see the "Posts" tab

  Scenario: User visits another user’s profile
    When I visit "other@tamu.edu" profile page
    Then I should see "Other User"'s name
    And I should see the "Created Projects" tab
    And I should see the "Joined Projects" tab
    And I should see the "Teacher" tab
    And I should see the "Student" tab
    And I should see the "Posts" tab
