Feature: User Sign In
  As an existing user
  I want to log in to my account
  So that I can access protected pages

  Background:
    Given a user exists with name "Saswat" and email "saswat@tamu.edu" and password "Passw0rd!"

  Scenario: Successful login
    Given I am on the login page
    When I fill in "Email" with "saswat@tamu.edu"
    And I fill in "Password" with "Passw0rd!"
    And I press "Log in"
    Then I should see "Signed in successfully"
    And I should be on the landing page

  Scenario: Invalid login
    Given I am on the login page
    When I fill in "Email" with "saswat@tamu.edu"
    And I fill in "Password" with "wrongpassword"
    And I press "Log in"
    Then I should see "Invalid Email or password"

  Scenario: User logs out
    Given I am logged in as "saswat@tamu.edu" with password "Passw0rd!"
    When I click "Logout"
    Then I should see "Signed out successfully."
    And I should be on the landing page
