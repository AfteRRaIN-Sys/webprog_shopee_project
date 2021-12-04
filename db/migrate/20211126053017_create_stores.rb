class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :storeName
      t.string :password_digest
      t.string :address

      t.timestamps
    end
  end
end
