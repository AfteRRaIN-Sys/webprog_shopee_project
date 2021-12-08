class Store < ApplicationRecord

	#assoc
	has_many :items, dependent: :destroy

	has_many :ratings, dependent: :destroy
	has_many :raters, through: :ratings, source: :user, dependent: :nullify

	#has_many :subscribers, :through => :subscriptions, :source => :user


	#has_many :favorites
	has_many :favorites, dependent: :destroy
	has_many :favor_users, through: :favorites, source: :user, dependent: :nullify

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
