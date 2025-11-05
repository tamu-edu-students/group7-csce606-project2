Given("I am on the sign up page") do
  visit new_user_registration_path
end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

When("I click {string}") do |link|
  click_link link
end

Given('a user exists with name {string} and email {string} and password {string}') do |name, email, password|
  user = User.find_or_initialize_by(email: email)
  user.update!(
    name: name,
    password: password,
    password_confirmation: password,
    confirmed_at: Time.now, # ensures confirmed user
    email_notifications: true
  )
end

Given('I am on the login page') do
  visit new_user_session_path
end

Then('I should be on the landing page') do
  visit root_path
end

Given("I am logged in as {string} with password {string}") do |email, password|
  Capybara.reset_sessions!  # ensures a clean browser session before login
  visit new_user_session_path

  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Log in"

  # Devise flash message check
  expect(page).to have_content("Signed in successfully")
end

Given('a reset password token exists for {string}') do |email|
  user = User.find_by(email: email)
  user.send_reset_password_instructions
end

When('I visit the password reset page') do
  visit new_user_password_path
end

When('I visit the password reset page with the token') do
  user = User.last
  # Generate a valid reset token the same way Devise does internally
  raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
  user.update!(
    reset_password_token: hashed_token,
    reset_password_sent_at: Time.current
  )
  visit edit_user_password_path(reset_password_token: raw_token)
end

When('the user visits the confirmation link') do
  user = User.last
  token = user.confirmation_token
  # If token doesn't exist (already confirmed or not generated), generate one
  unless token
    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user.update!(confirmation_token: enc)
    token = raw
  end
  visit user_confirmation_path(confirmation_token: token)
end

Given('an unconfirmed user exists with name {string} and email {string} and password {string}') do |name, email, password|
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password
  )
end


Then("a user should exist with email {string}") do |email|
  user = User.find_by(email: email)
  expect(user).not_to be_nil
end

Given("I am on the user creation page") do
  visit new_user_path
end

Then("I should be on the user creation page") do
  expect(page).to have_current_path(new_user_path)
end
