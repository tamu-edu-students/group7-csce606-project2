class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :memberable, polymorphic: true

  enum :status, [:pending, :approved, :rejected]
  validates :user_id, uniqueness: {
    scope: [:memberable_type, :memberable_id],
    message: "has already requested to join this"
  }
end
