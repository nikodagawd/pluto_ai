Rails.application.routes.draw do
  devise_for :users
  root "chat#index"
  get "/login", to: "pages#login", as: :login
  get "/signup", to: "pages#signup", as: :signup
  get "/goodbye", to: "pages#goodbye", as: :goodbye
  get "/about", to: "pages#about", as: :about
  get "/chat", to: "chat#index"
  post "/chat", to: "chat#create"

  # Stripe Payments (Lecture-Style)
  resources :orders, only: [:create, :show]
  get '/pricing', to: 'pricing#index'

  resources :lists, only: [:index, :show, :create, :destroy]
  resources :company_lists, only: [:create, :destroy]
end
