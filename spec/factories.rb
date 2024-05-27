# spec/factories.rb

FactoryBot.define do
  factory :user do
    first_name { (Faker::Name.name).split.first }
    last_name { (Faker::Name.name).split.second }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    role { "admin" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :auth_token do
    association :user
    token_digest { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  end

  factory :top_up do
    association :user
    amount { rand(100.0..20000.0).round(2) }
    phone_number { Faker::PhoneNumber.phone_number }
  end

  factory :transaction do
    association :user
    amount { rand(100.0..20000.0).round(2) }
  end

  factory :report do
    association :user
    start_date { Time.zone.now - 100.days }
    end_date { Time.zone.now }
  end

  factory :notification do
    association :user
    detail { Faker::Lorem.sentence }
  end
end
