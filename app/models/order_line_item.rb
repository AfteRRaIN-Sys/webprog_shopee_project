class OrderLineItem < ApplicationRecord

  #assoc
  belongs_to :order
  belongs_to :item

end
