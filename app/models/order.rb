class Order < ApplicationRecord

  #assoc
  belongs_to :user
  has_many :order_line_items
  has_many :items, through: :order_line_items

end
