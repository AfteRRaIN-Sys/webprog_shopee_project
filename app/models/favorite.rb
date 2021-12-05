class Favorite < ApplicationRecord
  
  #assoc
  belongs_to :user
  belongs_to :store
end
