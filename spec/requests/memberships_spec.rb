require "rails_helper"

RSpec.describe "Memberships", type: :request do
  let(:tutor) { create(:user, :confirmed) }
  let(:learner) { create(:user, :confirmed) }
  let!(:offer) { create(:teaching_offer, author: tutor, student_cap: 1) }

  before { sign_in learner }

  describe "POST /teaching_offers/:id/memberships" do
    it "creates a pending membership" do
      expect {
        post teaching_offer_memberships_path(offer)
      }.to change(Membership, :count).by(1)
      expect(Membership.last.status).to eq("pending")
    end
  end

  describe "PATCH /teaching_offers/:id/memberships/:id/approve" do
    before { sign_in tutor }

    it "approves a learner" do
      membership = create(:membership, user: learner, memberable: offer)
      patch approve_teaching_offer_membership_path(offer, membership)
      expect(membership.reload.status).to eq("approved")
    end
  end
end
