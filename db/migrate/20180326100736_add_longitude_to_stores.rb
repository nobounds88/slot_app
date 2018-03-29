class AddLongitudeToStores < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :longitude, :float
  end
end
