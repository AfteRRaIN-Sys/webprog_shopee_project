Rails.application.routes.draw do
  resources :users
  resources :stores
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # users -------------------------------------------------------------------------------
  #loginPage
  get "/userlogin", to: "application#userLoginPage"
  #login
  post "/userlogin", to: "application#userLogin"
  get "/users/main", to: "users#main"
  #end users -------------------------------------------------------------------------------

  # stores -------------------------------------------------------------------------------
  get "/storelogin", to: "application#storeLoginPage"
  #login
  post "/storelogin", to: "application#storeLogin"
  get "/stores/main", to: "stores#main"
  # end stores -------------------------------------------------------------------------------
end
