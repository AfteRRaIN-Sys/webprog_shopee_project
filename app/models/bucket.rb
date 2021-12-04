class Bucket < ApplicationRecord
  belongs_to :user
  has_many :item_on_buckets
  has_many :items, through: :item_on_buckets
end
