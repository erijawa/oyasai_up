class AddLineAlertToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :line_alert, :integer, null: false, default: 0
  end
end
