class TeachingOffer < ApplicationRecord
    belongs_to :author, class_name: "User", inverse_of: :teaching_offers
    has_many :memberships, as: :memberable, dependent: :destroy
    has_many :users, through: :memberships

    has_many :pending_memberships, -> { where(status: :pending) }, as: :memberable, class_name: "Membership"
    has_many :approved_memberships, -> { where(status: :approved) }, as: :memberable, class_name: "Membership"

    enum :offer_status, {
        pending: "pending",
        full:    "full",
        closed:  "closed"
    }

    attribute :offer_status, :string, default: "pending"

    has_many :pending_memberships, -> { where(status: :pending) }, as: :memberable, class_name: "Membership"
    has_many :approved_memberships, -> { where(status: :approved) }, as: :memberable, class_name: "Membership"
    validate :memberships_cannot_exceed_cap

    def memberships_cannot_exceed_cap
        if approved_memberships.size > student_cap
            errors.add(:memberships, "cannot exceed membership cap of #{student_cap}")
        end
    end

    def update_status
        if approved_memberships.size == student_cap
            update(offer_status: "full")
        elsif approved_memberships.size < student_cap
            update(offer_status: "pending")
        end
    end

    def close_offer 
        update(offer_status: "closed")
    end

end

