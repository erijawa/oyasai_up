FactoryBot.define do
  factory :post_form do
    sequence(:title) { |n| "タイトル#{n}" }
    mode { 0 }
    status { 0 }

    trait :with_recipe do
      mode { 10 }
      serving { 2 }
      ingredients_name { [ "材料1", "材料2" ] }
      ingredients_quantity { [ "分量1", "分量2" ] }
      steps_instruction { [ "手順1", "手順2" ] }
    end

    trait :with_recipe_draft do
      status { 1 }
      mode { 10 }
    end
  end
end
