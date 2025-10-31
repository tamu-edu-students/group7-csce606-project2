class TeachingOffer < ApplicationRecord
    belongs_to :author, class_name: "User", inverse_of: :teaching_offers
    has_many :memberships, as: :memberable, dependent: :destroy
    has_many :users, through: :memberships
end
