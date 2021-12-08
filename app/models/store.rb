class Store < ApplicationRecord

	#valid
	validates :storeName, presence: true, uniqueness: true, length: {minimum: 1}
	validates :password_digest, presence: true, length: {minimum: 1}
	validates :address, presence: true, length: {minimum: 1}

	#assoc
	has_many :items, dependent: :destroy

	has_many :ratings, dependent: :destroy
	has_many :raters, through: :ratings, source: :user

	#has_many :subscribers, :through => :subscriptions, :source => :user


	#has_many :favorites
	has_many :favorites, dependent: :destroy
	has_many :favor_users, through: :favorites, source: :user

	#password
	has_secure_password

	def getAllItems(sid)
		return Store.find(sid).items
	end

	def getSold(iid)
		quantity = OrderLineItem.where(item_id: iid).pluck('quantity')
		#puts "-------------quantity #{quantity}"
		return quantity.sum
	end

	def isAdmin
		return self.id == 2
	end

end
