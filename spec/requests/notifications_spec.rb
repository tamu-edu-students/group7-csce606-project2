require "rails_helper"

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user, :confirmed, email_notifications: true) }

  before { sign_in user }

  describe "GET /notifications" do
    it "shows notifications and marks unread as read" do
      create(:notification, user: user, read: false)
      get notifications_path
      expect(response).to have_http_status(:ok)
      expect(user.notifications.unread.count).to eq(0)
    end
  end

  describe "PATCH /notifications/toggle_email" do
    it "disables email notifications" do
      patch toggle_email_notifications_path, params: { user: { email_notifications: false } }
      expect(user.reload.email_notifications).to be false
    end
  end
end
