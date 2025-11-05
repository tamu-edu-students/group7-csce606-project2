Feature: Bulletin Posts
  As a user
  I want to view, create, edit, and delete bulletin posts
  So that I can communicate on the bulletin board

  Background:
    Given a user exists with name "Owner User" and email "owner@tamu.edu" and password "Password!"
    And a bulletin post exists with title "Original Title", description "Original description.", and author email "owner@tamu.edu"

  Scenario: Guest views bulletin posts index
    When I am on the bulletin posts page
    Then I should see "Original Title"

  Scenario: Logged-in user views bulletin posts index
    Given I am logged in as "owner@tamu.edu" with password "Password!"
    When I am on the bulletin posts page
    Then I should see "Original Title"

  Scenario: Logged-in user successfully searches posts
    Given I am logged in as "owner@tamu.edu" with password "Password!"
    When I am on the bulletin posts page
    And I fill in "query" with "Original"
    And I press "Search"
    Then I should see "Original Title"

  Scenario: Logged-in user creates a new post
    Given I am logged in as "owner@tamu.edu" with password "Password!"
    When I visit the new bulletin post page
    And I fill in "Title" with "A New Valid Title"
    And I fill in "Description" with "Some valid description."
    And I press "Post"
    Then I should see "Bulletin post was successfully created."
    And I should see "A New Valid Title"
    And I should see "Owner User"

  Scenario: Guest updates a post
    When I visit the edit page for the post "Original Title"
    And I fill in "Title" with "Updated Title"
    And I press "Post"
    Then I should see "Bulletin post was successfully updated."
    And I should see "Updated Title"

  Scenario: Logged-in user deletes a post
    Given I am logged in as "owner@tamu.edu" with password "Password!"
    When I visit the show page for the post "Original Title"
    And I press "Destroy this bulletin post"
    When I am on the bulletin posts page