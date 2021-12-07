class Order < ApplicationRecord

  #assoc
  belongs_to :user
  has_many :order_line_items
  has_many :items, through: :order_line_items

  def moveBucketToOrder(user_id, bucket_id)
    b = Bucket.find_by(id: bucket_id)
    if b != nil 
      #o = Order.new(user_id: user_id)
      self.user_id = user_id
      if self.save
        puts "--------------------created new order--------"
        table = Bucket.connection.select_all("select t1.item_id, t1.price,t1.quantity from (item_on_buckets IB INNER JOIN items I ON Ib.item_id = I.id) as t1 INNER JOIN buckets b ON b.id = t1.bucket_id and b.id = #{bucket_id}")
        #result : @columns=["item_id", "price", "quantity"]
        #result : [{"item_id"=>1, "price"=>59.5, "quantity"=>5},
        #          {"item_id"=>2, "price"=>20.0, "quantity"=>7},
        #          {"item_id"=>8, "price"=>99.0, "quantity"=>7}] 
        puts "--------------------query #{table.to_a}--------"
        if table.length == 0
          self.delete
          return false
        end
        table.each do |e|
          #create new orderlineitems
          puts "-------------------e : {order_id: #{self.id}, item_id: #{e["item_id"]}, quantity: #{e["quantity"]}, sold_price: #{e["price"]}}"
          puts "-------------------#{e}"
          tmp = OrderLineItem.new(order_id: self.id, item_id: e["item_id"], quantity: e["quantity"], sold_price: e["price"])
          
          if tmp.save == false
            self.deleteAllOrderLineItem
            return false
          end
        
        end

        return true
      
      end

    end

    self.delete
    return false

  end

  def deleteAllOrderLineItem
      puts "----------start delete all failed order"
      self.order_line_items.each do |ol|
        #delete success return the item instance
        d = ol.delete
        puts "----------deleted #{d.item_id}"
      end
  end

end
