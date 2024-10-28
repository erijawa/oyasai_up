class RecipeIngredient < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :quantity, presence: true, length: { maximum: 50 }

  belongs_to :post
end
