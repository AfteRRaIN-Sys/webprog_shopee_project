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

end
