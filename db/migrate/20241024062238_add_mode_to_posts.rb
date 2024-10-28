class AddModeToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :mode, :integer, null: false, default: 0
  end
end
