class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }

  mount_uploader :post_image, PostImageUploader

  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipe_steps, dependent: :destroy
  has_one :recipe_serving, dependent: :destroy

  enum :mode, { without_recipe: 0, with_recipe: 10 }, validate: true
end
