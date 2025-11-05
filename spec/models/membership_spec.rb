require "rails_helper"

RSpec.describe "MembershipsController", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:tutor)    { create(:user, :confirmed) }
  let(:learner)  { create(:user, :confirmed) }
  let(:offer)    { create(:teaching_offer, author: tutor) }
  let(:project)  { create(:project, author: tutor) }

  describe "POST /teaching_offers/:id/memberships#create" do
    context "when logged in as learner" do
      before { sign_in learner }

      it "creates a pending membership and notifies the tutor" do
        expect {
          post teaching_offer_memberships_path(offer)
        }.to change(Membership, :count).by(1)
         .and change(Notification, :count).by(1)

        membership = Membership.last
        expect(membership.status).to eq("pending")
        expect(membership.user).to eq(learner)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Join request sent!")
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        post teaching_offer_memberships_path(offer)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /teaching_offers/:id/memberships#index" do
    before { create(:membership, memberable: offer, user: learner, status: :pending) }

    context "when logged in as tutor" do
      before { sign_in tutor }

      it "shows pending memberships" do
        get teaching_offer_path(offer)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /teaching_offers/:offer_id/memberships/:id/approve" do
    let!(:membership) { create(:membership, memberable: offer, user: learner, status: :pending) }

    context "when logged in as tutor" do
      before { sign_in tutor }

      it "approves the membership and notifies the learner" do
        expect {
          patch approve_teaching_offer_membership_path(offer, membership)
        }.to change(Notification, :count).by(1)

        membership.reload
        expect(membership.status).to eq("approved")
        expect(response).to redirect_to(teaching_offer_memberships_path(offer))
        expect(flash[:notice]).to include("has been approved")
      end
    end

    context "when logged in as learner" do
      before { sign_in learner }

      it "redirects with not authorized alert" do
        patch approve_teaching_offer_membership_path(offer, membership)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Not authorized.")
      end
    end
  end

  describe "PATCH /teaching_offers/:offer_id/memberships/:id/reject" do
    let!(:membership) { create(:membership, memberable: offer, user: learner, status: :pending) }

    context "when logged in as tutor" do
      before { sign_in tutor }

      it "rejects the membership and notifies the learner" do
        expect {
          patch reject_teaching_offer_membership_path(offer, membership)
        }.to change(Notification, :count).by(1)

        membership.reload
        expect(membership.status).to eq("rejected")
        expect(response).to redirect_to(teaching_offer_path(offer))
        expect(flash[:notice]).to include("request has been rejected")
      end
    end

    context "when logged in as learner" do
      before { sign_in learner }

      it "redirects with permission error" do
        patch reject_teaching_offer_membership_path(offer, membership)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You don't have permission to do that.")
      end
    end
  end

  describe "DELETE /teaching_offers/:id/memberships#destroy" do
    let!(:membership) { create(:membership, memberable: offer, user: learner, status: :approved) }

    context "when logged in as learner" do
      before { sign_in learner }

      it "deletes the membership and notifies the tutor" do
        expect {
          delete teaching_offer_membership_path(offer, membership)
        }.to change(Membership, :count).by(-1)
         .and change(Notification, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include("You left this teachingoffer")
      end
    end
  end

  # ------------------------
  # PROJECT MEMBERSHIP PATHS
  # ------------------------
  describe "POST /projects/:id/memberships#create" do
    before { sign_in learner }

    it "creates a pending membership for project" do
      expect {
        post project_memberships_path(project)
      }.to change(Membership, :count).by(1)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Join request sent!")
    end
  end
end
