class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :name, presence: true, length: { maximum: 255 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :vegetable_logs, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  def own?(object)
    id == object&.user_id
  end
end
