Rails.application.routes.draw do
  devise_for :users
  root "chat#index"
  get "/login", to: "pages#login", as: :login
  get "/signup", to: "pages#signup", as: :signup
  post "/chat", to: "chat#create"

  resources :lists, only: [:index, :show, :create]
end
