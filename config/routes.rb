Rails.application.routes.draw do
  devise_for :users

  # Root path
  root "pages#home"

  # Chats with nested messages
  resources :chats, only: [:show, :create] do
    resources :messages, only: [:create]
  end

  # Companies
  resources :companies, only: [:show]

  # Lists with nested company_lists
  resources :lists, only: [:index, :show, :create] do
    resources :company_lists, only: [:create, :destroy]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
