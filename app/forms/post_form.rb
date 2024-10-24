class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend CarrierWave::Mount

  attribute :user_id, :integer
  attribute :title, :string
  attribute :description, :string
  attribute :post_image, :string

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }

  mount_uploader :post_image, PostImageUploader

  def save
    post = Post.create(user_id: user_id, title: title, description: description, post_image: post_image)
    post
  end
end