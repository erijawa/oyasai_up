class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 65_535 }

  mount_uploader :post_image, PostImageUploader

  belongs_to :user
  has_many :recipe_ingredients, dependent: :destroy
  has_many :recipe_steps, dependent: :destroy
  has_one :recipe_serving, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :bookmarks, dependent: :destroy

  enum :mode, { without_recipe: 0, with_recipe: 10 }, validate: true
  enum :status, { published: 0, draft: 1 }, validate: true

  scope :with_tag, ->(tag_name) { joins(:tags).where(tags: { name: tag_name }) }

  def save_tag(sent_tags)
    sent_tags.uniq!
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete(Tag.find_by(name: old))
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

  # Ransack用のホワイトリスト
  def self.searchable_attributes
    [ "title", "description", "mode" ]
  end
  def self.ransackable_attributes(auth_object = nil)
    [ "title", "description", "mode" ]
  end
  def self.ransackable_associations(auth_object = nil)
    [] # 検索可能な関連名を指定
  end
end
