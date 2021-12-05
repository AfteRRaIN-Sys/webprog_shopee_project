class ItemOnBucket < ApplicationRecord
  #assoc
  belongs_to :item
  belongs_to :bucket
end
