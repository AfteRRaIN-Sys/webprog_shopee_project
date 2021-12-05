class CreateOrderLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity
      t.float :sold_price
    end
  end
end
