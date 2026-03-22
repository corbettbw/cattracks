Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "posts#index"
  resource :profile, only: [:show, :edit, :update, :destroy]
  resources :cats do
    resources :sightings, only: [:new, :create, :destroy]
  end
  resources :posts, only: [:index, :show, :new, :create, :destroy]
end
