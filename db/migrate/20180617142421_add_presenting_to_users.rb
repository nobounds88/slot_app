class AddPresentingToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :presenting, :boolean, default: false, null: false
  end
end
