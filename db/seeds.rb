# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
ActiveRecord::Base.logger = nil

# Create users without triggering Devise confirmation emails
User.skip_callback(:create, :after, :send_on_create_confirmation_instructions) if User.respond_to?(:skip_callback)

User.create!(
  name: "Temp User",
  email: "temp@tamu.edu",
  password: "Password!",
  confirmed_at: Time.current
)

# Re-enable callback if you want it back for runtime
User.set_callback(:create, :after, :send_on_create_confirmation_instructions) if User.respond_to?(:set_callback)

BulletinPost.create!(title: "Example Bulletin Post", description: "Example description.", author: temp_user)
Project.create!(title: "Example Project", description: "Example description.", role_cnt: 5, author: temp_user, skills: "Example")
TeachingOffer.create!(title: "Example Teaching Offer", description: "Example description.", author: temp_user)
