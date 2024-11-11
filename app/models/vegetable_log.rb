class VegetableLog < ApplicationRecord
  with_options presence: true do
    validates :breakfast
    validates :lunch
    validates :diner
    validates :total
  end
  validates :date, presence: true, uniqueness: { scope: :user_id }
  belongs_to :user

  enum :breakfast, { none: 0, had_vegetable: 1 }, validate: true
  enum :lunch, { none: 0, had_vegetable: 1 }, validate: true
  enum :diner, { none: 0, had_vegetable: 1 }, validate: true

end
