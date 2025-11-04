class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    @unread_count = current_user.notifications.unread.count
    @notifications.unread.update_all(read: true)
  end

  def notification_link
    notification = current_user.notifications.find(params[:id])
    target = notification.notifiable.respond_to?(:memberable) ? notification.notifiable.memberable : notification.notifiable
    redirect_to polymorphic_path(target)
  end

  def toggle_email
    if current_user.update(email_notifications: params[:user][:email_notifications])
      status = current_user.email_notifications? ? "enabled" : "disabled"
      redirect_to notifications_path, notice: "Email notifications #{status}."
    else
      redirect_to notifications_path, alert: "Unable to update preference."
    end
  end

end
