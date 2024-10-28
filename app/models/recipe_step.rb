class RecipeStep < ApplicationRecord
  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :instruction, presence: true, length: { maximum: 150}

  belongs_to :post
end
