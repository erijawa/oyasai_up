class RecipeStep < ApplicationRecord
  # post_form.rbにて、レシピ付きの時のみ必須のバリデーションを設定済み
  validates :order,  numericality: { only_integer: true, greater_than: 0 }
  validates :instruction, length: { maximum: 150 }

  belongs_to :post
end
