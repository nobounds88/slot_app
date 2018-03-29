class AddAddressToStores < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :address, :string
  end
end
