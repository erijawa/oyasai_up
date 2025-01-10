FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "タイトル#{n}" }
    mode { 0 }
    status { 0 }
    association :user
  end
end
