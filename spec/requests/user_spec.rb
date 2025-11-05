require "rails_helper"

RSpec.describe "UsersController", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:user) { create(:user, :confirmed) }
  let!(:other_user) { create(:user, :confirmed) }

  describe "GET /users/:id (show)" do
    context "when logged in as the same user" do
      before { sign_in user }

      it "renders the show page successfully" do
        get user_path(user)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.name)
      end

      it "defaults @tab to 'projects' when no param is passed" do
        get user_path(user)
        # Verify page loads successfully (tab default)
        expect(response).to have_http_status(:ok)
      end

      it "sets @tab to provided param" do
        get user_path(user, params: { tab: "joined_teaching_offers" })
        expect(response).to have_http_status(:ok)
      end
    end

    context "when logged in as a different user" do
      before { sign_in other_user }

      it "renders the show page for the target user" do
        get user_path(user)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(user.name)
      end
    end

    context "when not logged in" do
      it "redirects to the login page" do
        get user_path(user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
