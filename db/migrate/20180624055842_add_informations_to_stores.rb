class AddInformationsToStores < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :informations, :text, default: "", null: false
  end
end
