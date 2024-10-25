class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend CarrierWave::Mount

  attribute :user_id, :integer
  attribute :title, :string
  attribute :description, :string
  attribute :post_image, :string
  attribute :mode, :integer
  attribute :serving, :integer
  attribute :ingredient_name, :string
  attribute :quantity, :string
  attribute :order, :integer
  attribute :instruction, :text

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }
  validates :serving, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :ingredient_name, presence: true, length: { maximum: 255 }
  validates :quantity, presence: true, length: { maximum: 50 }
  validates :order, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :instruction, presence: true, length: { maximum: 150}

  mount_uploader :post_image, PostImageUploader

  def save
    post = Post.create(user_id: user_id, title: title, description: description, post_image: post_image)
    post
  end
end