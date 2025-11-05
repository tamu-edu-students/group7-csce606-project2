FactoryBot.define do
  factory :notification do
    message { "Sample notification" }
    read { false }
    association :user
    association :notifiable, factory: :teaching_offer
    url { "/teaching_offers/1" }
  end
end
