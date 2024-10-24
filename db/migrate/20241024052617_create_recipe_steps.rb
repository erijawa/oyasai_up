class CreateRecipeSteps < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_steps do |t|
      t.references :post, null: false, foreign_key: true
      t.integer :order, null: false
      t.text :instruction, null: false

      t.timestamps
    end
  end
end
