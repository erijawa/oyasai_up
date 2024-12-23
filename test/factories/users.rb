FactoryBot.define do
  factory :user do
    name {"yasai"}
    sequence(:email) { |n| "yasai#{n}@example.com"}
    password {"password"}
  end
end
