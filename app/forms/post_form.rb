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
  attribute :tag_names

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }

  # with_options if: :with_recipe? do |recipe|
  #   recipe.validates :serving, presence: true
  #   recipe.validates :ingredients_name, presence: true, length: { maximum: 20 }
  #   recipe.validates :ingredients_quantity, presence: true, length: { maximum: 20 }
  #   recipe.validates :steps_instruction, presence: true, length: { maximum: 100 }
  # end

  # validate :no_blank

  mount_uploader :post_image, PostImageUploader

  def initialize(attributes = nil, post: Post.new)
    @post = post
    attributes ||= default_attributes
    super(attributes)
  end


  def save(tag_list)
    return false if invalid?
    ActiveRecord::Base.transaction do
      post = Post.new(user_id: user_id, title: title, description: description, post_image: post_image, mode: mode)
      if post.with_recipe?
        if ingredients_name.any?(&:blank?) || ingredients_quantity.any?(&:blank?) || steps_instruction.any?(&:blank?)
          errors.add(:base, 'フォームに空欄があります')
          return false
        end
      end
      post.save
      post.save_tag(tag_list)
      if post.with_recipe?
        post.create_recipe_serving(serving: serving)
        (ingredients_name.size).times do |index|
          post.recipe_ingredients.create(name: ingredients_name[index], quantity: ingredients_quantity[index])
        end
        (steps_instruction.size).times do |index|
          post.recipe_steps.create(order: index+1, instruction: steps_instruction[index])
        end
      end
      post
    end
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each do |message|
        errors.add(:base, message)
      end
    false

  end

  private

  attr_reader :post

  def default_attributes
    {
      # user_id: post.user_id,
      # title: post.title,
      # description: description,
      # post_image: post_image,
      # mode: mode,
      # serving: serving,
      ingredients_name: post.recipe_ingredients.map(&:name),
      ingredients_quantity: post.recipe_ingredients.map(&:quantity),
      steps_instruction: post.recipe_steps.map(&:instruction)
    }
  end

  # def with_recipe?
  #   return false unless self.mode == "10"
  # end

  # def no_blank
  #   errors.add(:base, 'フォームに空欄があります') if ingredients_name.any?(&:blank?) || ingredients_quantity.any?(&:blank?) || steps_instruction.any?(&:blank?)
  # end
end