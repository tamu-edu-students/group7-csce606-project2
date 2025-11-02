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

end
