# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(name: "Tasnia", email: "tasniajamal@tamu.edu", password: "passw0rd!")
    expect(user).to be_valid
  end

  it "rejects non-tamu emails" do
    user = User.new(name: "Tasnia", email: "itasniaj@gmail.com", password: "passw0rd!")
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("must be a tamu.edu email").or be_present
  end

  it "rejects short passwords" do
    user = User.new(name: "Tasnia", email: "tasniajamal@tamu.edu", password: "short1")
    expect(user).not_to be_valid
  end

  it "requires a name" do
    user = User.new(name: "", email: "tasniajamal@tamu.edu", password: "passw0rd!")
    expect(user).not_to be_valid
    expect(user.errors[:name]).to be_present
  end
end
