class NotificationMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  default from: "no-reply@bulletinapp.tech"

  def new_notification(notification)
    @notification = notification
    @user = notification.user

    base = ActionMailer::Base.default_url_options
    host     = base[:host] || "www.bulletinapp.tech"
    port     = base[:port] ? ":#{base[:port]}" : ""
    protocol = base[:protocol] || "https"
    path     = notification.url.to_s.start_with?("/") ? notification.url : "/#{notification.url}"

    @url = "#{protocol}://#{host}#{port}#{path}"

    mail(to: @user.email, subject: "New Notification from BulletinApp")
  end
end