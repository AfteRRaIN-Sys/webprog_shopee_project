class CreateItemOnBuckets < ActiveRecord::Migration[6.1]
  def change
    create_table :item_on_buckets do |t|
      t.references :item, null: false, foreign_key: true
      t.references :bucket, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
