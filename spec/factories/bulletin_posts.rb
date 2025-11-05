FactoryBot.define do
  factory :bulletin_post do
    sequence(:title) { |n| "Bulletin Post #{n}" }
    description { "A sample post for testing." }
    association :author, factory: :user
  end
end
