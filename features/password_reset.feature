Feature: Password Reset
  As a user who forgot my password
  I want to request a reset email
  So that I can set a new password

  Background:
    Given a user exists with name "Saswat" and email "saswat@tamu.edu" and password "Passw0rd!"

  Scenario: Requesting a password reset
    When I visit the password reset page
    And I fill in "Email" with "saswat@tamu.edu"
    And I press "Send me reset password instructions"
    Then I should see "You will receive an email with instructions"

  Scenario: Resetting password from email link
    Given a reset password token exists for "saswat@tamu.edu"
    When I visit the password reset page with the token
    And I fill in "New password" with "NewPass123!"
    And I fill in "Confirm new password" with "NewPass123!"
    And I press "Change my password"
    Then I should see "Your password has been changed successfully"
