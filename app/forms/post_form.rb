class PostForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend CarrierWave::Mount

  attribute :user_id, :integer
  attribute :title, :string
  attribute :description, :string
  attribute :post_image, :string
  attribute :mode, :integer
  attribute :status, :integer
  attribute :serving, :integer
  attribute :ingredients_name
  attribute :ingredients_quantity
  attribute :steps_instruction
  attribute :tag_names

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }

  with_options if: :with_recipe? do
    validates :serving, presence: true
    validate :no_blank_for_recipe_field
  end

  mount_uploader :post_image, PostImageUploader

  # 作成・更新に応じてフォームのアクションをPOST・PATCHに切り替える
  delegate :persisted?, to: :post

  def initialize(attributes = nil, post: Post.new)
    @post = post
    attributes ||= default_attributes
    super(attributes)
  end


  def save(tag_list)
    return false if invalid?
    ActiveRecord::Base.transaction do
      post = Post.create!(user_id: user_id, title: title, description: description, post_image: post_image, mode: mode, status: status)
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

  def update(tag_list)
    return false if invalid?
    ActiveRecord::Base.transaction do
      @post.update!(user_id: user_id, title: title, description: description, post_image: post_image, mode: mode, status: status)
      @post.save_tag(tag_list)
      if @post.with_recipe?
        @post.create_recipe_serving(serving: serving)
        @post.recipe_ingredients.clear
        @post.recipe_steps.clear
        (ingredients_name.size).times do |index|
          @post.recipe_ingredients.create(name: ingredients_name[index], quantity: ingredients_quantity[index])
        end
        (steps_instruction.size).times do |index|
          @post.recipe_steps.create(order: index+1, instruction: steps_instruction[index])
        end
      end
      @post
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
      user_id: post.user_id,
      title: post.title,
      description: post.description,
      post_image: post.post_image,
      tag_names: post.tags&.map(&:name)&.join(","),
      mode: post.mode_before_type_cast,
      status: post.status_before_type_cast,
      serving: post.recipe_serving&.serving,
      ingredients_name: post.recipe_ingredients&.map(&:name),
      ingredients_quantity: post.recipe_ingredients&.map(&:quantity),
      steps_instruction: post.recipe_steps&.map(&:instruction)
    }
  end

  def with_recipe?
    return true if mode == 10 && status == 0
    false
  end

  def no_blank_for_recipe_field
    if ingredients_name.nil?
      errors.add(:base, "材料が入力されていません")
      return false
    elsif steps_instruction.nil?
      errors.add(:base, "作り方が入力されていません")
      return false
    elsif ingredients_name.any?(&:blank?) || ingredients_quantity.any?(&:blank?) || steps_instruction.any?(&:blank?)
      errors.add(:base, "レシピ用フォームに空欄があります")
      return false
    end
  end
end
