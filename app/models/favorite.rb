class Favorite < ApplicationRecord
  
  #ASSOC
  belongs_to :user
  belongs_to :store
end
