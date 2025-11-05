Given('email notifications are enabled for {string}') do |email|
  user = User.find_by!(email: email)
  user.update!(email_notifications: true)
end

Given('email notifications are disabled for {string}') do |email|
  user = User.find_by!(email: email)
  user.update!(email_notifications: false)
end

When('a notification is created for {string} with message {string} and url {string}') do |email, message, url|
  user = User.find_by!(email: email)
  ActionMailer::Base.deliveries.clear
  Notification.create!(user: user, notifiable: user, message: message, url: url)
end

Then('an email should have been sent to {string} with subject {string}') do |email, subject|
  mail = ActionMailer::Base.deliveries.find { |m| m.to.include?(email) }
  expect(mail).not_to be_nil
  expect(mail.subject).to eq(subject)
end

Then('the email body should contain {string}') do |content|
  last_email = ActionMailer::Base.deliveries.last
  expect(last_email.body.encoded).to include(content)
end

Then('no email should have been sent to {string}') do |email|
  mail = ActionMailer::Base.deliveries.find { |m| m.to.include?(email) }
  expect(mail).to be_nil
end

Then('email notifications should be enabled for {string}') do |email|
  user = User.find_by!(email: email)
  expect(user.email_notifications?).to eq(true)
end

When('I check {string}') do |label_text|
  check(label_text)
end
