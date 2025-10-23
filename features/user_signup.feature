Feature: User Sign Up
  Scenario: Successful sign up
    Given I am on the sign up page
    When I fill in "Name" with "Saswat"
    And I fill in "Email" with "saswat@tamu.edu"
    And I fill in "Password" with "passw0rd!"
    And I fill in "Password confirmation" with "passw0rd!"
    And I press "Sign up"
    Then I should see "Welcome! You have signed up successfully."