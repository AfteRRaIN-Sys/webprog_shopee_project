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

	#password
	has_secure_password

end
