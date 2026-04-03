Rails.application.routes.draw do
  get "notifications/index"
  get "browse", to: "browse#index", as: :browse
  get "search", to: "search#index", as: :search
  root "posts#index"

  get "/tos", to: "pages#tos", as: :tos
  get "/privacy", to: "pages#privacy_policy", as: :privacy_policy
  get "/support", to: "pages#support", as: :support

  resources :notifications, only: [:index]
  
  namespace :autocomplete do
    get :users
    get :cats
  end

  resource :session
  resources :passwords, param: :token
  resources :users, only: [:new, :create, :show] do
    member do
      post :follow
      delete :unfollow
      get :followers
      get :following
    end
  end
  resource :profile, only: [:show, :edit, :update, :destroy]
  resources :cats do
    member do
      post :claim
      delete :leave
      post :follow
      delete :unfollow
    end
    resources :sightings, only: [:new, :create, :destroy, :show, :edit, :update]
  end
  resources :posts, only: [:index, :show, :new, :create, :destroy]
end
