class User < ApplicationRecord

	validates :email, presence: true, uniqueness: true
	validates :username, presence: true, uniqueness: true
	validates :name, presence: true, uniqueness: true
	validates :password_digest, length: {minimum: 1}
	validates :address, presence: true, length: {minimum: 1}
	validates :phoneNo, presence: true, uniqueness: true
	validates :gender, presence: true
	#validates :birthday

	#association
	has_one :bucket

	has_many :ratings
	has_many :rated_stores, through: :ratings, source: :store #source : "store" in rating

	has_many :orders

	has_many :favorites
	has_many :favorite_stores, through: :favorites, source: :store

	#password
	has_secure_password

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
end
