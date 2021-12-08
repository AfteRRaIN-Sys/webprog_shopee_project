class RemoveUnusedCol < ActiveRecord::Migration[6.1]
  def change
    #remove_column :tags, :created_at, :timestamp
    remove_column :buckets, :quantity
    remove_column :orders, :purchased_time

    add_column :users, :img_src, :string
    add_column :stores, :img_src, :string
  end
end
