class CreateVegetableLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :vegetable_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :breakfast, null: false, default: 0
      t.integer :lunch, null: false, default: 0
      t.integer :dinner, null: false, default: 0
      t.integer :total, null: false, default: 0
      t.date :date, null: false, default: -> { '(CURRENT_DATE)' }

      t.timestamps
    end
  end
end
