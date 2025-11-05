class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :memberable, polymorphic: true
  after_save :update_memberable_status, if: :saved_change_to_status?

  enum :status, {
    pending:  "pending",
    approved: "approved",
    rejected: "rejected"
  }

  validates :user_id, uniqueness: {
    scope: [:memberable_type, :memberable_id],
    message: "has already requested to join this"
  }

  validate :respect_student_cap, if: :approving_teaching_offer?

  private

  # ✅ 1️⃣ Validation: prevent exceeding the student cap
  def respect_student_cap
    return unless memberable.respond_to?(:student_cap)

    approved_count = memberable.approved_memberships.where.not(id: id).count
    if approved_count >= memberable.student_cap.to_i
      errors.add(:base, "Cannot approve more learners — teaching offer is already full.")
    end
  end

  # ✅ 2️⃣ Run this validation only when approving a TeachingOffer
  def approving_teaching_offer?
    memberable_type == "TeachingOffer" && status_changed? && status == "approved"
  end

  # ✅ 3️⃣ Update parent status after save
  def update_memberable_status
    memberable.update_status if memberable.respond_to?(:update_status)
  end
end
