class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend CarrierWave::Mount

  attribute :user_id, :integer
  attribute :title, :string
  attribute :description, :string
  attribute :post_image, :string
  attribute :mode, :integer
  attribute :serving
  attribute :ingredients_name
  attribute :ingredients_quantity
  attribute :steps_instruction

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }

  mount_uploader :post_image, PostImageUploader

  def save
    post = Post.create(user_id: user_id, title: title, description: description, post_image: post_image, mode: mode)
    if post.with_recipe?
      post.create_recipe_serving(serving: serving)
      3.times do |index|
        post.recipe_ingredients.create(name: ingredients_name[index], quantity: ingredients_quantity[index])
      end
      3.times do |index|
        post.recipe_steps.create(order: index+1, instruction: steps_instruction[index])
      end
    end

    post
  end
end