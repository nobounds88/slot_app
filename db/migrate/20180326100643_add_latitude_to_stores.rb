class AddLatitudeToStores < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :latitude, :float
  end
end
