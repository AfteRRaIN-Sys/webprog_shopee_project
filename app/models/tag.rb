class Tag < ApplicationRecord

	#assoc
	has_and_belongs_to_many :items

end
