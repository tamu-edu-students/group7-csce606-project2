FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Distributed Systems Project #{n}" }
    description { "A project focused on scalable distributed computing." }
    skills { "Ruby, Rails, PostgreSQL" }
    role_cnt { 3 }
    status { "open" }

    association :author, factory: :user

    trait :closed do
      status { "closed" }
    end
  end
end
