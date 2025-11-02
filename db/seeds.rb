# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

temp_user = User.create!(name: "Temp User", password: "Password123", email: "temp@tamu.edu")
BulletinPost.create!(title: "Example Bulletin Post", description: "Example description.", author: temp_user)
Project.create!(title: "Example Project", description: "Example description.", role_cnt: 5, author: temp_user, skills: "Example")
TeachingOffer.create!(title: "Example Teaching Offer", description: "Example description.", author: temp_user)
