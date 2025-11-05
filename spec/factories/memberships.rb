FactoryBot.define do
  factory :membership do
    association :user
    association :memberable, factory: :teaching_offer
    status { "pending" }
  end
end
