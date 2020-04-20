Rails.application.routes.draw do
  get "/", to: "home#index"
  patch "/orders/pay", to: "orders#pay"
  post "/orders/addmore", to: "orders#addmore"
  get "/orders/bill", to: "orders#bill", as: :bill
  resources :menus
  resources :users
  resources :menuitems
  resources :orders
  resources :orderitems

  post "/menus/setmenu", to: "menus#set", as: :setmenu
  get "/signin", to: "sessions#new", as: :new_sessions
  post "/signin", to: "sessions#create", as: :sessions
  delete "/signout", to: "sessions#destroy", as: :destroy_session
end
