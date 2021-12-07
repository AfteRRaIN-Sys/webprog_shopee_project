class Favorite < ApplicationRecord
  
  #assoc
  belongs_to :user
  belongs_to :store

  def isAlreadyAdd(user_id, store_id)
    return Favorite.where(store_id: store_id, user_id: user_id) == nil
  end

end
