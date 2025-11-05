Given('a teaching offer exists with title {string} and description {string} and author email {string} and studentcap {int}') do |title, description, email, studentcap|
  author = User.find_by!(email: email)
  TeachingOffer.create!(
    title: title,
    description: description,
    student_cap: studentcap,
    author: author
  )
end

When('I visit the show page for the teaching offer {string}') do |title|
  offer = TeachingOffer.find_by!(title: title)
  visit teaching_offer_path(offer)
end

When('I visit the memberships page for {string}') do |title|
  offer = TeachingOffer.find_by!(title: title)
  visit teaching_offer_memberships_path(offer)
end

Given('{string} has a pending membership in {string}') do |email, title|
  user = User.find_by(email: email)
  offer = TeachingOffer.find_by(title: title)

  membership = Membership.create!(user: user, memberable: offer, status: :pending)

  Notification.create!(
    user: offer.author,
    notifiable: membership,
    message: "#{user.name} has requested to join your teaching offer.",
    url: Rails.application.routes.url_helpers.teaching_offer_path(offer)
  )
end


Given('{string} has an approved membership in {string}') do |email, offer_title|
  user = User.find_by!(email: email)
  offer = TeachingOffer.find_by!(title: offer_title)
  Membership.create!(user: user, memberable: offer, status: :approved)
end

Then('a membership should exist for {string} in {string} with status {string}') do |email, offer_title, status|
  user = User.find_by!(email: email)
  offer = TeachingOffer.find_by!(title: offer_title)
  m = Membership.find_by(user: user, memberable: offer)
  expect(m).not_to be_nil
  expect(m.status).to eq(status)
end

Then('no membership should exist for {string} in {string}') do |email, offer_title|
  user = User.find_by!(email: email)
  offer = TeachingOffer.find_by!(title: offer_title)
  expect(Membership.find_by(user: user, memberable: offer)).to be_nil
end

Then('a notification should be sent to {string} saying {string}') do |email, substring|
  user = User.find_by!(email: email)
  latest = Notification.where(user: user).order(created_at: :desc).first
  expect(latest).not_to be_nil
  expect(latest.message).to include(substring)
end

# Visits the new teaching offer creation page
When('I visit the new teaching offer page') do
  visit new_teaching_offer_path
end

# Visits the edit page for a specific teaching offer
When('I visit the edit page for the teaching offer {string}') do |title|
  offer = TeachingOffer.find_by!(title: title)
  visit edit_teaching_offer_path(offer)
end

# Clicks an action button (Approve/Reject) next to a user's name
When('I press {string} next to {string}') do |button_text, user_name|
  li = find(:xpath, "//li[contains(.,'#{user_name}')]")
  within(li) do
    click_button(button_text)
  end
end

# Visits the notifications index page
When('I visit the notifications page') do
  visit notifications_path
end

When('I visit the teaching offers page') do
  visit teaching_offers_path
end

Given('a teaching offer exists with title {string} and description {string} and author email {string} and studentcap {int} and status {string}') do |title, description, email, cap, status|
  author = User.find_by!(email: email)
  TeachingOffer.create!(
    title: title,
    description: description,
    author: author,
    student_cap: cap,
    offer_status: status
  )
end

Given('a teaching offer exists with title {string} and description {string} and author {string}') do |title, description, email|
  author = User.find_by(email: email)
  TeachingOffer.create!(title: title, description: description, author: author, student_cap: 5)
end

When('I am on the teaching offers page') do
  visit teaching_offers_path
end

Given('a teaching offer exists with title {string} and description {string} and author {string} and student cap {int}') do |title, description, email, cap|
  author = User.find_by!(email: email)
  TeachingOffer.create!(title: title, description: description, author: author, student_cap: cap)
end


Given('both {string} and {string} have pending memberships in {string}') do |name1, name2, title|
  offer = TeachingOffer.find_by!(title: title)
  [name1, name2].each do |name|
    user = User.find_by!(name: name)
    Membership.create!(user: user, memberable: offer, status: :pending)
  end
end

When('the learner leaves the teaching offer {string}') do |title|
  offer = TeachingOffer.find_by(title: title)
  membership = offer.memberships.find_by(status: :approved)
  membership.destroy!
  offer.update_status
end

Then('the teaching offer {string} should have status {string}') do |title, expected_status|
  offer = TeachingOffer.find_by(title: title)
  expect(offer.offer_status).to eq(expected_status)
end

When('I visit the teaching offers search URL with query {string}') do |query|
  visit teaching_offers_path(query: query)
end

Given('I am logged out') do
  Capybara.reset_sessions!
end