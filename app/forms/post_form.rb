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
  attribute :ingredients_name
  attribute :ingredients_quantity
  attribute :steps_instruction

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }

  # validate :recipe_presence

  mount_uploader :post_image, PostImageUploader

  # 編集、更新機能実装時に使用予定
  # def initialize(attributes = nil, post: Post.new)
  #   @post = post
  #   attributes ||= default_attributes
  #   super(attributes)
  # end

  # def default_attributes
  #   {
  #     entries_contents: diary.diary_entries.map(&:content),
  #     entries_ids: diary.diary_entries.map(&:id)
  #   }
  # end

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

  private

  # def recipe_presence
  #   return false if images.blank?
  # end
end