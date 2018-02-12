class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.integer :user_id
      t.integer :store_id
      t.string :model
      t.integer :seat
      t.datetime :start_at
      t.datetime :end_at
      t.integer :investment
      t.integer :proceeds

      t.timestamps
    end
  end
end
