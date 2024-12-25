class RecipeServing < ApplicationRecord
  # post_form.rbにて、レシピ付きの時のみ必須のバリデーションを設定済み
  validates :serving, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :post
end
