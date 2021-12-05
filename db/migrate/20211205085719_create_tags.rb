class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    create_join_table :items, :tags do |t|
      t.index :item_id
      t.index :tag_id
    end

  end
end
