class Item < ApplicationRecord
  
  #assoc
  belongs_to :store

  #has_and_belongs_to_many :buckets

  has_many :item_on_buckets
  has_many :buckets, through: :item_on_buckets 
  
  has_many :order_line_items
  has_many :orders, through: :order_line_items

  
  has_and_belongs_to_many :tags, dependent: :destroy

  def addItemTag(tag_str)
    arr = tag_str.split(" ")
    arr.each do |tag|
      puts "---------tag #{tag}"
      if (tag!=nil && tag.length>0)
        #tag already exists
        t = Tag.find_by(name: tag)
        if t == nil
          t = Tag.create(name: tag.downcase)
        end
        self.tags.append(t)

      else
        flash[:error] = "Tag are nil or empty string"
        return false
      end
    end
    self.save
    return true
  end


end
