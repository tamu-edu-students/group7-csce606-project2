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
  end
  
  it "shows error for non-tamu emails" do
    user = User.new(name: "Tasnia", email: "itasniaj@gmail.com", password: "passw0rd!")
    user.valid?
    expect(user.errors[:email]).to include("must be a tamu.edu email")
  end

  it "rejects short passwords" do
    user = User.new(name: "Tasnia", email: "tasniajamal@tamu.edu", password: "short1")
    expect(user).not_to be_valid
  end

  it "requires a name" do
    user = User.new(name: "", email: "tasniajamal@tamu.edu", password: "passw0rd!")
    expect(user).not_to be_valid
    # expect(user.errors[:name]).to be_present
  end

  it "has no duplicate accounts with same email" do
    user = User.create!(name: "Tasnia", email: "tasniajamal@tamu.edu", password: "passw0rd!")
    duplicate_user = User.new(name: "Another Tasnia", email: "tasniajamal@tamu.edu", password: "anotherPass1!")
    expect(duplicate_user).not_to be_valid
  end
  it "shows error for duplicate email" do
    user = User.create!(name: "Tasnia", email: "tasniajamal@tamu.edu", password: "passw0rd!")
    duplicate_user = User.new(name: "Another Tasnia", email: "tasniajamal@tamu.edu", password: "anotherPass1!")
    duplicate_user.valid?
    expect(duplicate_user.errors[:email]).to include("has already been taken")
  end
end
