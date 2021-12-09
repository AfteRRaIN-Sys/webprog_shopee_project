class Rating < ApplicationRecord

  #validate
  #validates :price, presence: true, numericality: {greater_than: 0}
  validates :rate_score, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5}
  :greater_than_or_equal_to

  #assoc
  belongs_to :user
  belongs_to :store


end
