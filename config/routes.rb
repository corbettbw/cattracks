Rails.application.routes.draw do
  root "posts#index"
  get "users/new"
  get "users/create"
  resource :session
  resources :passwords, param: :token
  resources :users, only: [:new, :create]
  resource :profile, only: [:show, :edit, :update, :destroy]
  resources :cats do
    resources :sightings, only: [:new, :create, :destroy]
  end
  resources :posts, only: [:index, :show, :new, :create, :destroy]
end
