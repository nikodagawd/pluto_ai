Rails.application.routes.draw do
  devise_for :users
  root "chat#index"
  post "/chat", to: "chat#create"

  resources :lists, only: [:index, :show, :create]
end
