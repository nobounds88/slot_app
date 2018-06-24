class CreateStoreUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :store_users do |t|
      t.integer :user_id
      t.integer :store_id
      t.integer :saved_balls

      t.timestamps
    end
  end
end
