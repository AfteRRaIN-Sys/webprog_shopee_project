class DelDateFromTag < ActiveRecord::Migration[6.1]
  def change
    remove_column :tags, :created_at, :timestamp
    remove_column :tags, :updated_at, :timestamp
  end
end
