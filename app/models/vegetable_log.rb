class VegetableLog < ApplicationRecord
  with_options presence: true do
    validates :breakfast
    validates :lunch
    validates :dinner
    validates :total
  end
  validates :date, presence: true, uniqueness: { scope: :user_id }
  belongs_to :user

  def calculate_total
    total = breakfast + lunch+ dinner
    self.update(total: total)
  end
end
