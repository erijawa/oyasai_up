class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 65_535 }

  mount_uploader :post_image, PostImageUploader

  belongs_to :user
end
