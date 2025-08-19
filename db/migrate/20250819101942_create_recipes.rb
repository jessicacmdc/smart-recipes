class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :ingredients
      t.string :instruction
      t.string :category
      t.integer :required_time
      t.string :difficulty_level
      t.string :serves
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
