Feature: Manage Projects
  As a registered user
  I want to view, search, create, edit, and manage projects
  So that I can collaborate with other users

  Background:
    Given a confirmed user "alice@tamu.edu" with password "Passw0rd!"
    And a confirmed user "bob@tamu.edu" with password "Passw0rd!"
    And the following projects exist:
      | title               | description        | skills       | author_email     |
      | Distributed Systems | Learn Zookeeper    | Ruby, Kafka  | alice@tamu.edu   |
      | Cloud Data Pipeline | Build ETL pipelines | Python, SQL  | bob@tamu.edu     |

  Scenario: Searching for a project as a logged-in user
    Given I am logged in as "alice@tamu.edu"
    When I visit the projects page
    And I fill in "Search by title or description:" with "Cloud"
    And I press "Search"
    Then I should see "Cloud Data Pipeline"
    And I should not see "Distributed Systems"

  Scenario: Creating a new project
    Given I am logged in as "alice@tamu.edu"
    When I visit the new project page
    And I fill in "Title" with "AI System Design"
    And I fill in "Description" with "Work on scalable ML pipelines"
    And I fill in "Skills" with "Python, ML"
    And I press "Create Project"
    Then I should see "Project was successfully created."
    And I should see "AI System Design"

  @edit
  Scenario: Editing an existing project
    Given I am logged in as "alice@tamu.edu"
    And I visit the project page for "Distributed Systems"
    When I click "Edit"
    And I fill in "Title" with "Distributed Systems - Updated"
    And I press "Update Project"
    Then I should see "Project was successfully updated."
    And I should see "Distributed Systems - Updated"

  @permissions
  Scenario: Non-owner cannot edit or delete another user’s project
    Given I am logged in as "bob@tamu.edu"
    When I visit the project page for "Distributed Systems"
    Then I should not see "Edit"
    And I should not see "Delete this project"

  @status
  Scenario: Project owner can close and reopen a project
    Given I am logged in as "alice@tamu.edu"
    When I visit the project page for "Distributed Systems"
    And I press "Close Listing"
    Then I should see "Project listing closed!"
    And I should see "This project is closed for new collaborators."
    When I press "Reopen Listing"
    Then I should see "Project listing reopened!"
