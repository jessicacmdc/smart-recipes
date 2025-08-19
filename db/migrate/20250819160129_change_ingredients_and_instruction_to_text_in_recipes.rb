class ChangeIngredientsAndInstructionToTextInRecipes < ActiveRecord::Migration[7.1]
  def change
    change_column :recipes, :ingredients, :text
    change_column :recipes, :instruction, :text
  end
end
