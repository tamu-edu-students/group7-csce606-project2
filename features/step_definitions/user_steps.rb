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
  User.create!(name: name, email: email, password: password)
end

Given('I am on the login page') do
  visit new_user_session_path
end

Then('I should be on the landing page') do
  visit root_path
end

Given("I am logged in as {string} with password {string}") do |email, password|
  visit new_user_session_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Log in"
  expect(page).to have_content("Signed in successfully")
end