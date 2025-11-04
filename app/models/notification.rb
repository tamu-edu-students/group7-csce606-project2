class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }
  
  after_create_commit :send_email_if_enabled
  
  private

  def send_email_if_enabled
    return unless user.email_notifications?
    NotificationMailer.new_notification(self).deliver_later
  end
end
