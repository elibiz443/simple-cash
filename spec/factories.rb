# spec/factories.rb

FactoryBot.define do
  factory :user do
    first_name { (Faker::Name.name).split.first }
    last_name { (Faker::Name.name).split.second }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :auth_token do
    association :user
    token_digest { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  end

  factory :top_up do
    amount { rand(100.0..20000.0).round(2) }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
