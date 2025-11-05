require "rails_helper"

RSpec.describe Users::ConfirmationsController, type: :request do
  let(:user) { create(:user, :unconfirmed) }

  it "confirms user successfully" do
    get user_confirmation_path(confirmation_token: user.confirmation_token)
    expect(response).to redirect_to(root_path)
    expect(flash[:notice]).to include("confirmed successfully")
  end

  it "renders new with errors on invalid token" do
    get user_confirmation_path(confirmation_token: "invalid")
    expect(response).to have_http_status(:unprocessable_entity)
    expect(flash[:alert]).to be_present
  end
end
