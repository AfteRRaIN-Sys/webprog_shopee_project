class CreateFavorites < ActiveRecord::Migration[6.1]
  def change

    drop_table :favorites

    create_table :favorites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
    end
  end
end
