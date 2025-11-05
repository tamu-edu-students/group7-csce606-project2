Feature: Teaching Offers
  As a tutor
  I want to create and manage teaching offers
  So that I can teach students and control enrollment

  Background:
    Given a user exists with name "Tutor User" and email "tutor@tamu.edu" and password "Passw0rd!"
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"

  Scenario: Tutor creates a new teaching offer
    When I visit the teaching offers page
    And I click "Create a New Offer"
    And I fill in "Title" with "Distributed Systems 101"
    And I fill in "Description" with "Learn the fundamentals of distributed systems."
    And I fill in "Student cap" with "3"
    And I press "Create Teaching offer"
    Then I should see "Teaching offer was successfully created."
    And I should see "Distributed Systems 101"

  Scenario: Tutor edits a teaching offer
    Given a teaching offer exists with title "Ruby Basics" and description "Intro" and author email "tutor@tamu.edu" and studentcap 2
    When I visit the show page for the teaching offer "Ruby Basics"
    And I click "Edit this teaching offer"
    And I fill in "Title" with "Ruby for Beginners"
    And I press "Update Teaching offer"
    Then I should see "Teaching offer was successfully updated."
    And I should see "Ruby for Beginners"

  Scenario: Tutor closes a teaching offer
    Given a teaching offer exists with title "AI Foundations" and description "Intro to ML" and author email "tutor@tamu.edu" and studentcap 3
    When I visit the show page for the teaching offer "AI Foundations"
    And I press "Close this teaching offer"
    Then I should see "Teaching offer closed successfully."

  Scenario: Closed teaching offers are hidden from index
    Given a user exists with name "Tutor" and email "tutor@tamu.edu" and password "Passw0rd!"
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    And a teaching offer exists with title "Open Offer" and description "Visible" and author email "tutor@tamu.edu" and studentcap 3 and status "pending"
    And a teaching offer exists with title "Closed Offer" and description "Hidden" and author email "tutor@tamu.edu" and studentcap 3 and status "closed"
    And a teaching offer exists with title "Full Offer" and description "Hidden" and author email "tutor@tamu.edu" and studentcap 3 and status "full"
    When I visit the teaching offers page
    Then I should see "Open Offer"
    And I should not see "Closed Offer"
    And I should not see "Full Offer"

  Scenario: Logged-in user searches for teaching offers
    Given a user exists with name "Tutor User" and email "tutor@tamu.edu" and password "Passw0rd!"
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    And a teaching offer exists with title "Ruby Basics" and description "Learn core Ruby concepts" and author "tutor@tamu.edu"
    And a teaching offer exists with title "Python ML" and description "Machine learning with Python" and author "tutor@tamu.edu"
    When I am on the teaching offers page
    And I fill in "query" with "Rubi"
    And I press "Search"
    Then I should see "Ruby Basics"
    And I should not see "Python ML"

   Scenario: Tutor cannot approve more learners than the student cap
    Given a user exists with name "Tutor User" and email "tutor@tamu.edu" and password "Passw0rd!"
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    And a teaching offer exists with title "Ruby Basics" and description "Learn core Ruby concepts" and author "tutor@tamu.edu" and student cap 1
    And a user exists with name "Learner One" and email "learner1@tamu.edu" and password "Passw0rd!"
    And a user exists with name "Learner Two" and email "learner2@tamu.edu" and password "Passw0rd!"
    And both "Learner One" and "Learner Two" have pending memberships in "Ruby Basics"
    When I visit the show page for the teaching offer "Ruby Basics"
    And I press "Approve" next to "Learner One"
    And I press "Approve" next to "Learner Two"
    Then I should see "Cannot approve more learners — teaching offer is already full"

  Scenario: Teaching offer automatically becomes full when student cap is reached
    Given a user exists with name "Tutor User" and email "tutor@tamu.edu" and password "Passw0rd!"
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    And a teaching offer exists with title "Python ML" and description "Intro to Python ML" and author "tutor@tamu.edu" and student cap 1
    And a user exists with name "Learner User" and email "learner@tamu.edu" and password "Passw0rd!"
    And "learner@tamu.edu" has a pending membership in "Python ML"
    When I visit the show page for the teaching offer "Python ML"
    And I press "Approve" next to "Learner User"
    Then I should see "Python ML"
    And the teaching offer "Python ML" should have status "full"

  Scenario: Teaching offer returns to pending when learners leave
    Given a user exists with name "Tutor User" and email "tutor@tamu.edu" and password "Passw0rd!"
    And a user exists with name "Learner User" and email "learner@tamu.edu" and password "Passw0rd!"
    And a teaching offer exists with title "Rails Basics" and description "Learn Rails" and author "tutor@tamu.edu" and student cap 1
    And "learner@tamu.edu" has an approved membership in "Rails Basics"
    When the learner leaves the teaching offer "Rails Basics"
    Then the teaching offer "Rails Basics" should have status "pending"

  Scenario: Guest search is redirected to login with an alert
    Given a teaching offer exists with title "Ruby Basics" and description "Intro to Ruby" and author email "tutor@tamu.edu" and studentcap 2
    And I am logged out
    When I visit the teaching offers search URL with query "Ruby"
    Then I should be on the login page
    And I should see "You need to sign in or sign up before continuing"

  Scenario: Tutor fails to create a teaching offer due to missing title
    Given I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    When I visit the new teaching offer page
    And I fill in "Title" with ""
    And I fill in "Description" with "Some description"
    And I fill in "Student cap" with "2"
    And I press "Create Teaching offer"
    Then I should see "prohibited this teaching_offer from being saved"
    
  Scenario: Tutor fails to update a teaching offer with invalid data
    Given a teaching offer exists with title "Cloud Basics" and description "Intro to cloud" and author email "tutor@tamu.edu" and studentcap 2
    And I am logged in as "tutor@tamu.edu" with password "Passw0rd!"
    When I visit the show page for the teaching offer "Cloud Basics"
    And I click "Edit this teaching offer"
    And I fill in "Title" with ""
    And I press "Update Teaching offer"
    Then I should see "prohibited this teaching_offer from being saved"
       
