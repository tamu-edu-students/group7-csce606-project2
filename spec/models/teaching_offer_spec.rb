require "rails_helper"

RSpec.describe TeachingOffer, type: :model do
  let(:tutor) { create(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      offer = build(:teaching_offer, author: tutor)
      expect(offer).to be_valid
    end

    it "is invalid without a title" do
      offer = build(:teaching_offer, title: nil, author: tutor)
      expect(offer).not_to be_valid
    end
  end

  describe "#validate_student_cap" do
    it "prevents approving more learners than the cap" do
        offer = create(:teaching_offer, student_cap: 1)
        create(:membership, memberable: offer, status: "approved")

        over_limit = build(:membership, memberable: offer, status: "approved")

        expect(over_limit).not_to be_valid
        expect(over_limit.errors[:base]).to include("Cannot approve more learners — teaching offer is already full.")
    end
  end

  describe "#update_status" do
    it "marks offer as full when cap reached" do
      offer = create(:teaching_offer, author: tutor, student_cap: 1)
      create(:membership, memberable: offer, status: "approved")
      offer.update_status
      expect(offer.offer_status).to eq("full")
    end

    it "marks offer as pending when below cap" do
      offer = create(:teaching_offer, author: tutor, student_cap: 2)
      create(:membership, memberable: offer, status: "approved")
      offer.update_status
      expect(offer.offer_status).to eq("pending")
    end
  end

  describe "#close_offer" do
    it "sets offer_status to closed" do
      offer = create(:teaching_offer, author: tutor)
      offer.close_offer
      expect(offer.offer_status).to eq("closed")
    end
  end
end
