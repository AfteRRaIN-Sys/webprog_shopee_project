class Item < ApplicationRecord
  
  #assoc
  belongs_to :store

  #has_and_belongs_to_many :buckets

  has_many :item_on_buckets
  has_many :buckets, through: :item_on_buckets 
  
  has_many :order_line_items
  has_many :orders, through: :order_line_items

  
  has_and_belongs_to_many :tags



end
