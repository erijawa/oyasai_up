class AddLevelToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :level, :integer, null: false, default: 0
  end
end
