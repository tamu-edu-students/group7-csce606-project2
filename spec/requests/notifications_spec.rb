require "rails_helper"

RSpec.describe "Notifications", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, :confirmed, email_notifications: true) }
  let!(:notification) { create(:notification, user: user, read: false, message: "Hello!") }

  before { sign_in user }

  describe "GET /notifications" do
    it "renders notifications and marks unread as read" do
      get notifications_path
      expect(response).to be_successful
      expect(assigns(:notifications)).to include(notification)
      expect(assigns(:unread_count)).to eq(1)
      expect(notification.reload.read).to be true
    end
  end

  describe "PATCH /notifications/toggle_email" do
    it "disables email notifications" do
      patch toggle_email_notifications_path, params: { user: { email_notifications: false } }
      expect(response).to redirect_to(notifications_path)
      expect(flash[:notice]).to include("disabled")
    end

    it "shows alert on update failure" do
      allow_any_instance_of(User).to receive(:update).and_return(false)
      patch toggle_email_notifications_path, params: { user: { email_notifications: false } }
      expect(flash[:alert]).to eq("Unable to update preference.")
    end
  end
end
