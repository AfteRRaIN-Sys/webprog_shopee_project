class CreateRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.integer :rate_score
      t.string :comment

      t.timestamps
    end
  end
end
