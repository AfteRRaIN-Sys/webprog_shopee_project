class NameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    #unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    unless Store.find_by(id: store_id).items.find_by(name: value) == nil
      record.errors.add attribute, (options[:message] || "is already selling in the shop!")
    end
  end
end

class Item < ApplicationRecord
  
  #validatename addItem already check redundant item name
  validates :name, presence: true, length: {minimum: 1}
  validates :price, presence: true, numericality: {greater_than: 0}

  #assoc
  belongs_to :store

  #has_and_belongs_to_many :buckets

  has_many :item_on_buckets, dependent: :destroy
  has_many :buckets, through: :item_on_buckets
  
  has_many :order_line_items, dependent: :destroy
  has_many :orders, through: :order_line_items

  
  has_and_belongs_to_many :tags

  def addItemTag(tag_str)
    arr = tag_str.split(" ")
    arr.each do |tag|
      tag = tag.downcase
      puts "---------tag #{tag}"
      if (tag!=nil && tag.length>0)
        #check tag already exists
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

  def getPlusIcon
    #return "http://cdn.onlinewebfonts.com/svg/img_51677.png"
    return "https://cdn1.iconfinder.com/data/icons/ui-colored-1/100/UI__2-512.png"
  end

  def clearBeforeDelete
    self.deleteAllOrderLine
    self.deleteAllItemOnBucket
  end

  def deleteAllOrderLine
    ol = OrderLineItem.where(item_id: self.id)
    ol.each do |e|
      e.delete
    end
  end

  def deleteAllItemOnBucket
    ib = ItemOnBucket.where(item_id: self.id)
    ib.each do |e|
      e.delete
    end
  end


end
