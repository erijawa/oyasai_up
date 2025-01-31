class AddMaxPostCountToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :max_post_count, :integer, null: false, default: 0
  end
end
