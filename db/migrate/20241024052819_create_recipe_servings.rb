class CreateRecipeServings < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_servings do |t|
      t.references :post, null: false, foreign_key: true
      t.integer :serving, null: false

      t.timestamps
    end
  end
end
