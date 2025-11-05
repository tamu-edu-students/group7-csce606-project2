Given("a confirmed user {string} with password {string}") do |email, password|
  User.create!(
    email: email,
    name: email.split("@").first.capitalize,
    password: password,
    password_confirmation: password,
    confirmed_at: Time.current
  )
end

Given("the following projects exist:") do |table|
  table.hashes.each do |row|
    author = User.find_by!(email: row["author_email"])
    Project.create!(
      title: row["title"],
      description: row["description"],
      skills: row["skills"],
      role_cnt: 2,
      status: "open",
      author: author
    )
  end
end

Given("I am logged in as {string}") do |email|
  user = User.find_by!(email: email)
  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: "Passw0rd!"
  click_button "Log in"
end

When("I visit the projects page") do
  visit projects_path
end

When("I visit the new project page") do
  visit new_project_path
end

When("I visit the project page for {string}") do |title|
  project = Project.find_by!(title: title)
  visit project_path(project)
end
