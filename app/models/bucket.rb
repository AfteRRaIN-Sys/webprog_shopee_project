class Bucket < ApplicationRecord
  
  #assoc
  belongs_to :user
  
  has_many :item_on_buckets
  has_many :items, through: :item_on_buckets

  serialize :quantity

  def clearBucket
    ids = ItemOnBucket.where(bucket_id: self.id).pluck("id")
    puts "--------------#{ids.to_a}"
    ItemOnBucket.delete(ids)
  end

  #OrderLineItem.where(item_id: iid).pluck('quantity')
  def getCurrentStoreFromBucket
    puts "-----------------get sid from bucket"
    sid = self.items[0].store_id
    puts "-------------------#{sid}"
    return sid
  end

  def checkBucketItemToStore(store_id)
    if self.items.size != 0 && self.getCurrentStoreFromBucket != store_id
      self.clearBucket 
    end
  end

  def addItemToBucket(item_id)
    puts "--------add item to bucket"
    i = Item.find_by(id: item_id)

    checkBucketItemToStore(i.store_id)

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

  def getAllItemFromBucket
    #version1
    return self.item_on_buckets
  end

  def getTotalPayment
    return ItemOnBucket.connection.select_all("SELECT sum(quantity*price) as total FROM item_on_buckets IB INNER JOIN items I ON Ib.item_id = I.id and Ib.bucket_id = #{self.id}").pluck("total")[0]
  end

end
