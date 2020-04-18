Rails.application.routes.draw do
  get "/", to: "home#index"
  resources :menus
  resources :users
  resources :menuitems
  resources :orders
  get "/create_orderitem", to: "orderitems#create"
  post "/menus/setmenu", to: "menus#set", as: :setmenu
  get "/signin", to: "sessions#new", as: :new_sessions
  post "/signin", to: "sessions#create", as: :sessions
  delete "/signout", to: "sessions#destroy", as: :destroy_session
end
