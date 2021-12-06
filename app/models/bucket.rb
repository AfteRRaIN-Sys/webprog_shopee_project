class Bucket < ApplicationRecord
  
  #assoc
  belongs_to :user
  
  has_many :item_on_buckets
  has_many :items, through: :item_on_buckets

  serialize :quantity

  def clearBucket
    ids = ItemOnBucket.where(bucket_id: self.id).pluck("id")
    puts "--------------#{ids.to_a}"
    #ItemOnBucket.delete(ids)
  end

  def addItemToBucket(item_id)
    puts "--------add item to bucket"
    i = Item.find_by(id: item_id)
    if i != nil
      ib = ItemOnBucket.find_by(bucket_id: self.id, item_id: item_id)
      if ib != nil
        ib.quantity = ib.quantity+1
        puts "--------found ib, add quantity from #{ib.quantity-1} to #{ib.quantity}"
      else
        ib = ItemOnBucket.new(bucket_id: self.id, item_id: item_id, quantity: 1)
        puts "--------create new ib"
      end
      return ib.save
    end
    return false
  end


end
