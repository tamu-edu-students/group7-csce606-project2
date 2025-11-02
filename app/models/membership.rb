class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :memberable, polymorphic: true
  after_save :update_memberable_status, if: :saved_change_to_status?

  def update_memberable_status
    memberable.update_status if memberable.respond_to?(:update_status)
  end

  enum :status, {
    pending: "pending",
    approved: "approved",
    rejected: "rejected"
  }

  validates :user_id, uniqueness: {
    scope: [:memberable_type, :memberable_id],
    message: "has already requested to join this"
  }
end 
