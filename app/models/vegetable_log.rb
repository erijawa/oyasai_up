class VegetableLog < ApplicationRecord
  with_options presence: true do
    validates :breakfast
    validates :lunch
    validates :dinner
    validates :total
  end
  validates :date, presence: true, uniqueness: { scope: :user_id }
  belongs_to :user

  enum :breakfast, { no_vegetable: 0, had_vegetable: 1 }, validate: true, prefix: true
  enum :lunch, { no_vegetable: 0, had_vegetable: 1 }, validate: true, prefix: true
  enum :dinner, { no_vegetable: 0, had_vegetable: 1 }, validate: true, prefix: true

  def calculate_total
    total = self.breakfast_before_type_cast.to_i + self.lunch_before_type_cast.to_i + self.dinner_before_type_cast.to_i
    self.update(total: total)
  end

end
