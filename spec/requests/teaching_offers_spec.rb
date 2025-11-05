require "rails_helper"

RSpec.describe "TeachingOffers", type: :request do
  let(:tutor) { create(:user, :confirmed) }
  let(:learner) { create(:user, :confirmed) }
  let!(:offer) { create(:teaching_offer, author: tutor, student_cap: 2) }

  before { sign_in tutor }
  before { sign_in learner }

   describe "GET /index" do
    it "lists only pending offers" do
      get teaching_offers_path
      expect(response).to be_successful
      expect(response.body).to include(offer.title)
    end
  end

  describe "POST /teaching_offers" do
    before { sign_in tutor }

    it "creates a new teaching offer" do
      expect {
        post teaching_offers_path, params: { teaching_offer: attributes_for(:teaching_offer) }
      }.to change(TeachingOffer, :count).by(1)
      expect(response).to redirect_to(TeachingOffer.last)
    end
  end

  describe "PATCH /teaching_offers/:id/close" do
    before { sign_in tutor }

    it "closes an offer" do
      patch close_teaching_offer_path(offer)
      expect(offer.reload.offer_status).to eq("closed")
    end
  end
end
