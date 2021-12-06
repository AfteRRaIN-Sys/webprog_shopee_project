class AddImgsrcToItem < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :img_src, :string
  end
end
