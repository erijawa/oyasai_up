class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, uniqueness: true, presence: true, length: { maximum: 20 }
end
