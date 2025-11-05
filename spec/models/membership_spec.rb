require "rails_helper"

RSpec.describe Membership, type: :model do
  let(:tutor) { create(:user) }
  let(:learner) { create(:user) }
  let(:offer) { create(:teaching_offer, author: tutor, student_cap: 2) }

  describe "validations" do
    it "is valid with unique user per offer" do
      membership = build(:membership, user: learner, memberable: offer)
      expect(membership).to be_valid
    end

    it "is invalid with duplicate user for same offer" do
      create(:membership, user: learner, memberable: offer)
      duplicate = build(:membership, user: learner, memberable: offer)
      expect(duplicate).not_to be_valid
    end
  end

  describe "#update_memberable_status" do
    it "updates offer status when approved" do
      membership = create(:membership, user: learner, memberable: offer, status: "pending")
      membership.update(status: "approved")
      expect(offer.reload.offer_status).to eq("pending") # below cap
    end
  end
end
