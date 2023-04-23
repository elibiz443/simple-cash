# spec/factories.rb

FactoryBot.define do
  factory :user do
    first_name { (Faker::Name.name).split.first }
    last_name { (Faker::Name.name).split.second }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    balance { rand(10000.0..50000.0).round(2) }
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
end
