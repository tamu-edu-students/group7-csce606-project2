# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:name)  { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@tamu.edu" }
    password { "Passw0rd!" }

    # Mark user as confirmed by default so sign_in works in most specs
    confirmed_at { Time.current }

    # ────────────────
    # Traits
    # ────────────────

    trait :unconfirmed do
      confirmed_at { nil }
      confirmation_token { SecureRandom.hex(10) }
      confirmation_sent_at { Time.current }
    end

    trait :confirmed do
      confirmed_at { Time.current }
      confirmation_token { nil }
      confirmation_sent_at { nil }
    end

    trait :recoverable do
      reset_password_token { Devise.friendly_token }
      reset_password_sent_at { Time.current }
    end

    trait :tutor do
      name  { "Tutor User" }
      email { "tutor@tamu.edu" }
    end

    trait :learner do
      name  { "Learner User" }
      email { "learner@tamu.edu" }
    end

    trait :with_notifications_enabled do
      email_notifications { true }
    end

    trait :with_notifications_disabled do
      email_notifications { false }
    end

  end
end
