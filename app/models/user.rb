class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors.add attribute, (options[:message] || "is not an email")
    end
  end
end

class GenderValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.downcase == "male" || value.downcase == "female"
      record.errors.add attribute, (options[:message] || "is invalid gender")
    end
  end
end

class User < ApplicationRecord

	validates :email, presence: true, uniqueness: true, length: {minimum: 1}
	#validates :email, presence: true, uniqueness: true, email: true
	validates :username, presence: true, uniqueness: true, length: {minimum: 1}
	validates :name, presence: true, uniqueness: true, length: {minimum: 1}
	validates :password_digest, presence: true, length: {minimum: 1}
	validates :address, presence: true, length: {minimum: 1}
	validates :phoneNo, presence: true, uniqueness: true, numericality: { only_integer: true }
	validates :gender, presence: true, gender: true
	#validates :birthday

	#  validates :card_number, presence: true, if: :paid_with_card?

	# def paid_with_card?
  	#   payment_type == "card"
  	# end

	#association
	has_one :bucket, dependent: :delete

	has_many :ratings, dependent: :delete_all
	has_many :rated_stores, through: :ratings, source: :store #source : "store" in rating

	has_many :orders, dependent: :delete_all

	has_many :favorites, dependent: :delete_all
	has_many :favorite_stores, through: :favorites, source: :store

	#password
	has_secure_password

	#app method
	def isAlreadyAdd(store_id)
    	f = Favorite.where(store_id: store_id, user_id: self.id).to_a
    	puts "------------------isAlreadyAdd #{f}"
    	return f.size != 0
  	end

	def addToFavorite(store_id)
		if self.isAlreadyAdd(store_id) == false
			f = Favorite.new(store_id: store_id, user_id: self.id)
			return f.save
		end
		return false

	end

	def removeFromFavorite(store_id)
		if self.isAlreadyAdd(store_id)
			f = Favorite.find_by(user_id: self.id, store_id: store_id)
			f.delete
			return true
		end
		return false
	end

	def getAllItemFromFavorites
		#version1
		arr = []
		self.favorite_stores.each do |f|
			arr = arr+f.items
		end

		return arr

		#v2 must sort by, group by tag
		
	end

	def getAllPrevOrder
		table = User.connection.select_all("select * from (select O.user_id, O.id as order_id, O.purchased_time, OL.id as orderLine_id,\
                                         ol.item_id, ol.quantity, ol.sold_price from \
                                         (select u.id as user_id, o.id, o.created_at as purchased_time from users u INNER JOIN ORDERs O ON u.id = o.user_id and u.id = #{self.id}) as O \
                                         INNER JOIN order_line_items OL ON OL.order_id = o.id) \
                                         as o INNER JOIN \
                                         (select s.id as store_id, i.id as item_id from stores s INNER JOIN items i ON i.store_id = s.id) \
                                         as s ON o.item_id = s.item_id group by order_id")
    	return table
	end

	def getAllPrevOrderLineItem
		table = User.connection.select_all("select * from (select O.user_id, O.id as order_id, O.purchased_time, OL.id as orderLine_id,\
                                         ol.item_id, ol.quantity, ol.sold_price from \
                                         (select u.id as user_id, o.id, o.created_at as purchased_time from users u INNER JOIN ORDERs O ON u.id = o.user_id and u.id = #{self.id}) as O \
                                         INNER JOIN order_line_items OL ON OL.order_id = o.id) \
                                         as o INNER JOIN \
                                         (select s.id as store_id, i.id as item_id from stores s INNER JOIN items i ON i.store_id = s.id) \
                                         as s ON o.item_id = s.item_id")
    	return table
	end

	def getOrder(order_id)
		return self.orders.find_by(id: order_id)
	end

	def createNewBucket
		b = Bucket.new(user_id: self.id)
		return b.save
	end

	def getAllItemFromBucket
		#version1
		return self.bucket.getAllItemFromBucket
	end

	def clearBucket
		b = self.bucket
		b.clearBucket
	end

	def isAdmin
      puts "------check admin"
      return self.id == 1
    end
end
