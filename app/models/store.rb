class Store < ApplicationRecord

	#assoc
	has_many :items

	has_many :ratings
	has_many :raters, through: :ratings, source: :user

	#has_many :subscribers, :through => :subscriptions, :source => :user


	#has_many :favorites
	has_many :favorites
	has_many :favor_users, through: :favorites, source: :user

	#password
	has_secure_password

end
