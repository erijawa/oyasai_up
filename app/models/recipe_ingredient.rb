class RecipeIngredient < ApplicationRecord
  # post_form.rbにて、レシピ付きの時のみ必須のバリデーションを設定済み
  validates :name, length: { maximum: 255 }
  validates :quantity, length: { maximum: 50 }

  belongs_to :post
end
