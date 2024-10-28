class RecipeServing < ApplicationRecord
  validates :serving, presence: true, numericality: { only_integer: true, greater_than: 0 }

  belongs_to :post
end
