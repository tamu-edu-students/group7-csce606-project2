require "rails_helper"

RSpec.describe Notification, type: :model do
  let(:tutor) { create(:user, email_notifications: true) }
  let(:offer) { create(:teaching_offer, author: tutor) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:notifiable) }
  end

  describe "#send_email_if_enabled" do
    it "sends email when email notifications are enabled" do
      notification = build(:notification, user: tutor, notifiable: offer)
      mailer = instance_double(ActionMailer::MessageDelivery, deliver_later: true)

      expect(NotificationMailer).to receive(:new_notification).and_return(mailer)
      notification.save!
    end

    it "does not send email when email notifications are disabled" do
      tutor.update(email_notifications: false)
      notification = build(:notification, user: tutor, notifiable: offer)

      expect(NotificationMailer).not_to receive(:new_notification)
      notification.save!
    end
  end
end
