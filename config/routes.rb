Rails.application.routes.draw do
  resources :users
  resources :stores
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # users -------------------------------------------------------------------------------
  #loginPage
  get "/userlogin", to: "application#userLoginPage"
  #login
  post "/userlogin", to: "application#userLogin"
  get "/usermain", to: "users#main"

  get "/add_item_to_bucket/:added_item_id", to: "users#addItemToBucket"

  get "/visitStore/:store_id", to: "users#visitStore"
  

  #end users -------------------------------------------------------------------------------

  # stores -------------------------------------------------------------------------------
  
  get "/storelogin", to: "application#storeLoginPage"
  #login
  post "/storelogin", to: "application#storeLogin"
  get "/storemain", to: "stores#main"

  get "/add_item", to: "stores#addItem"
  post "/add_item", to: "stores#checkAddItem"


  # end stores -------------------------------------------------------------------------------
end
