class RemoveFromUserFromMessages < ActiveRecord::Migration[7.1]
  def change
  remove_column :messages, :from_user, :boolean
  end
end
