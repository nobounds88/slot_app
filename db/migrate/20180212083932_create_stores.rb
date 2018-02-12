class CreateStores < ActiveRecord::Migration[5.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :name_kana
      t.string :area

      t.timestamps
    end
  end
end
