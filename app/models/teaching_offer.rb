class TeachingOffer < ApplicationRecord
    belongs_to :author, class_name: "User", inverse_of: :teaching_offers
    has_many :memberships, as: :memberable, dependent: :destroy
    has_many :users, through: :memberships

    has_many :pending_memberships, -> { where(status: :pending) }, as: :memberable, class_name: "Membership"
    has_many :approved_memberships, -> { where(status: :approved) }, as: :memberable, class_name: "Membership"
end
