class Bucket < ApplicationRecord
  
  #assoc
  belongs_to :user
  
  has_many :item_on_buckets
  has_many :items, through: :item_on_buckets

  serialize :quantity
end
