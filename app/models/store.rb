class Store < ApplicationRecord

	#assoc
	has_many :items

	has_many :ratings

	has_many :favorites

	#password
	has_secure_password

end
