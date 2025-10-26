Feature: User Sign Up
  As a new visitor
  I want to create an account
  So that I can use the app
  
  Background:
    Given a user exists with name "Saswat" and email "saswatmishra@tamu.edu" and password "Passw0rd!"

  Scenario: Successful sign up
    Given I am on the sign up page
    When I fill in "Name" with "Saswat"
    And I fill in "Email" with "saswat@tamu.edu"
    And I fill in "Password" with "passw0rd!"
    And I fill in "Password confirmation" with "passw0rd!"
    And I press "Sign up"
    Then I should see "Welcome! You have signed up successfully."

  Scenario: Sign-up with invalid email
    Given I am on the sign up page
    When I fill in "Name" with "Saswat"
    And I fill in "Email" with "saswat@gmail.com"
    And I fill in "Password" with "Passw0rd!"
    And I fill in "Password confirmation" with "Passw0rd!"
    And I press "Sign up"
    Then I should see "must be a tamu.edu email"

  Scenario: Sign-up with weak password
    Given I am on the sign up page
    When I fill in "Name" with "Saswat"
    And I fill in "Email" with "saswat@tamu.edu"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Sign up"
    Then I should see "must include at least one number or special character"  

  Scenario: Attempting to sign up with an existing email
    Given I am on the sign up page
    When I fill in "Name" with "Duplicate User"
    And I fill in "Email" with "saswatmishra@tamu.edu"
    And I fill in "Password" with "Passw0rd!"
    And I fill in "Password confirmation" with "Passw0rd!"
    And I press "Sign up"
    Then I should see "Email has already been taken"
