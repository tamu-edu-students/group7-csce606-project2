

When("I visit my profile page") do
  user = User.find_by(email: "tutor@tamu.edu") # or current_user
  visit user_path(user)
end

When("I visit {string} profile page") do |email|
  user = User.find_by(email: email)
  visit user_path(user)
end


Then("I should see my name") do
  user = User.find_by(email: "tutor@tamu.edu")
  expect(page).to have_content(user.name)
end

Then("I should see {string}'s name") do |name|
  expect(page).to have_content(name)
end

Then("I should see the {string} tab") do |tab_name|
  expect(page).to have_link(tab_name)
end

