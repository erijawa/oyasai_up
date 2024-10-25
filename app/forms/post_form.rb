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
  attribute :ingredients
  attribute :steps

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }

  mount_uploader :post_image, PostImageUploader

  def save
    post = Post.create(user_id: user_id, title: title, description: description, post_image: post_image, mode: mode)

    if post.has_recipe?
      post.recipe_serving.build(serving: serving[:serving])
      post_params[:ingredients].to_h.values.map do |ingredient|
        post.recipe_ingredients.build(name: ingredient[:name], quantity: ingredient[:quantity])
      end
      post_params[:steps].to_h.values.map do |step|
        post.recipe_steps.build(order: step[:order], instruction: step[:instruction])
      end
    end

    post
  end
end