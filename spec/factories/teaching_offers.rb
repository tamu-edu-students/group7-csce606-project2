FactoryBot.define do
  factory :teaching_offer do
    sequence(:title) { |n| "Offer #{n}" }
    description { "Learn something new!" }
    student_cap { 2 }
    offer_status { "pending" }
    association :author, factory: :user
  end
end
