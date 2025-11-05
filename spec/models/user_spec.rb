# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  #
  # ───────────────────────────────
  # Validations
  # ───────────────────────────────
  #
  describe "validations" do
    it "is valid with valid attributes" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is invalid with duplicate email (case-insensitive)" do
      create(:user, email: "saswat@tamu.edu")
      dup = build(:user, email: "SASWAT@tamu.edu")
      expect(dup).not_to be_valid
    end

    it "adds an error for duplicate email" do
      create(:user, email: "saswat@tamu.edu")
      dup = build(:user, email: "saswat@tamu.edu")
      dup.valid?
      expect(dup.errors[:email]).to include("has already been taken")
    end

    it "rejects non-tamu emails" do
      user = build(:user, email: "someone@gmail.com")
      expect(user).not_to be_valid
    end

    it "adds an error for non-tamu emails" do
      user = build(:user, email: "someone@gmail.com")
      user.valid?
      expect(user.errors[:email]).to include("must be a tamu.edu email")
    end

    it "is invalid with short password" do
      user = build(:user, password: "short1")
      expect(user).not_to be_valid
    end

    it "is invalid without a name" do
      user = build(:user, name: "")
      expect(user).not_to be_valid
    end
  end

  #
  # ───────────────────────────────
  # Confirmable
  # ───────────────────────────────
  #
  describe "confirmable" do
    let(:unconfirmed_user) { create(:user, :unconfirmed) }

    it "is unconfirmed after creation" do
      expect(unconfirmed_user.confirmed?).to be false
    end

    it "generates a confirmation token" do
      expect(unconfirmed_user.confirmation_token).to be_present
    end

    it "has nil confirmed_at initially" do
      expect(unconfirmed_user.confirmed_at).to be_nil
    end

    it "becomes confirmed after calling confirm" do
      unconfirmed_user.confirm
      expect(unconfirmed_user.confirmed?).to be true
    end

    it "sets confirmed_at timestamp after confirmation" do
      unconfirmed_user.confirm
      expect(unconfirmed_user.confirmed_at).not_to be_nil
    end

    it "is not active for authentication before confirmation" do
      expect(unconfirmed_user.active_for_authentication?).to be false
    end
  end

  #
  # ───────────────────────────────
  # Recoverable
  # ───────────────────────────────
  #
  describe "recoverable" do
    let(:user) { create(:user) } # confirmed by default in factory

    it "generates a reset token when instructions are sent" do
      token = user.send_reset_password_instructions
      expect(token).to be_present
    end

    it "stores reset_password_token after sending instructions" do
      user.send_reset_password_instructions
      expect(user.reset_password_token).to be_present
    end

    it "stores reset_password_sent_at timestamp" do
      user.send_reset_password_instructions
      expect(user.reset_password_sent_at).not_to be_nil
    end

    it "resets password successfully with valid token" do
      token = user.send_reset_password_instructions
      reset_user = described_class.reset_password_by_token(
        reset_password_token: token,
        password: "NewPassw0rd!",
        password_confirmation: "NewPassw0rd!"
      )
      expect(reset_user.valid_password?("NewPassw0rd!")).to be true
    end

    it "adds an error for invalid reset token" do
      reset_user = described_class.reset_password_by_token(
        reset_password_token: "invalid",
        password: "NewPassw0rd!",
        password_confirmation: "NewPassw0rd!"
      )
      expect(reset_user.errors[:reset_password_token]).to be_present
    end
  end
end
