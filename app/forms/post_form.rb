class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend CarrierWave::Mount

  attribute :title, :string
  attribute :description, :string
  attribute :post_image, :string

  validates :title, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 65_535 }

  mount_uploader :post_image, PostImageUploader

  def save
    post = Post.new(title: title, description: description, post_image: post_image).save!
    post
  end
end