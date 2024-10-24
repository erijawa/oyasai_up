class CreateRecipeIngredients < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_ingredients do |t|
      t.references :post, null: false, foreign_key: true
      t.string :name, null: false
      t.string :quantity, null: false

      t.timestamps
    end
  end
end
