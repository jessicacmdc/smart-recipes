class ChangeIngredientsToJsonbInRecipes < ActiveRecord::Migration[7.1]
  def change
    remove_column :recipes, :ingredients, :text
    add_column :recipes, :ingredients, :jsonb, default: [], null: false
  end
end
