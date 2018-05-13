Rails.application.routes.draw do

  root 'images#index'

  resources :images do
    member do
      get 'share'
      post 'send_email'
    end
  end

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resources :likes, only: [:create, :destroy]
end
