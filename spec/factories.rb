# spec/factories.rb

FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    balance    { 100.0 }
    password   { "password" }
    sequence(:email) { |n| "john.doe#{n}@example.com" }
    sequence(:phone_number) { |n| "555-555-#{n.to_s.rjust(4, '0')}" }
  end
end