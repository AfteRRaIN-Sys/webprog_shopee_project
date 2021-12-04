json.extract! store, :id, :storeName, :password_digest, :address, :created_at, :updated_at
json.url store_url(store, format: :json)
