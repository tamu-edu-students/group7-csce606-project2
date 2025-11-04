# frozen_string_literal: true

# Step to create a bulletin post associated with a user found by email
Given("a bulletin post exists with title {string}, description {string}, and author email {string}") do |title, description, email|
  # Find the author by email, which should have been created by a user step
  author = User.find_by(email: email)

  # Raise an error if the author isn't found, which helps debugging
  raise "Author user with email #{email} not found. Ensure a user is created first." unless author

  # Create the bulletin post
  BulletinPost.create!(title: title, description: description, author: author)
end

# Step to navigate to the bulletin posts index page
When("I am on the bulletin posts page") do
  visit bulletin_posts_path
end

# Step to navigate to the new bulletin post page
When("I visit the new bulletin post page") do
  visit new_bulletin_post_path
end

# Step to navigate to the edit page for a specific post found by title
When("I visit the edit page for the post {string}") do |title|
  post = BulletinPost.find_by(title: title)
  visit edit_bulletin_post_path(post)
end

When("I visit the show page for the post {string}") do |title|
  post = BulletinPost.find_by(title: title)
  visit bulletin_post_path(post)
end

When("I visit the bulletin posts page with query {string}") do |query|
  visit "#{bulletin_posts_path}?query=#{CGI.escape(query)}"
end

# Step to navigate to the show page for a specific post found by title
When("I am on the page for the post {string}") do |title|
  post = BulletinPost.find_by(title: title)
  visit bulletin_post_path(post)
end

# Step to assert that text is NOT visible on the page
Then("I should not see {string}") do |text|
  expect(page).not_to have_content(text)
end

# Step to assert that the user is currently on the login page
Then('I should be on the login page') do
  expect(current_path).to eq(new_user_session_path)
end