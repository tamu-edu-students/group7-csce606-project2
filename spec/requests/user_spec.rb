
require 'rails_helper'

RSpec.describe "Users", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:valid_attrs) { { name: "Test User", email: "testuser@tamu.edu", password: "passw0rd!" } }
  let(:invalid_attrs) { { name: "", email: "not_tamu@gmail.com", password: "short" } }

  describe "GET /users" do
    let!(:user) { User.create!(name: "Owner", email: "owner@tamu.edu", password: "passw0rd!") }
    before { sign_in user }
    it "renders the devise/index template" do
      get users_path
      expect(response).to have_http_status(:ok)
      expect(response).to render_template("devise/index")
    end
  end


  describe "authorization for edit/update/destroy" do
    let!(:user) { User.create!(name: "Owner", email: "owner@tamu.edu", password: "passw0rd!") }
    let!(:other) { User.create!(name: "Other", email: "other@tamu.edu", password: "passw0rd!") }

    context "when not the owner" do
      before { sign_in other }

      it "blocks access to edit" do
        get edit_user_path(user)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("You are not authorized to access this page.")
      end


      it "blocks destroy" do
        delete user_path(user)
        expect(response).to redirect_to(root_path)
        expect(User.exists?(user.id)).to be true
      end
    end

    context "when the owner" do
      before { sign_in user }

      it "renders edit" do
        get edit_user_path(user)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end

      it "updates successfully and redirects" do
        patch user_path(user), params: { user: { name: "Updated Name" } }
        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        expect(response.body).to include("User was successfully updated.")
        expect(user.reload.name).to eq("Updated Name")
      end

      it "destroys the account and redirects to users list" do
        expect {
          delete user_path(user)
        }.to change(User, :count).by(-1)
        expect(response).to redirect_to(users_path)
        follow_redirect!
      end
    end
  end
end
