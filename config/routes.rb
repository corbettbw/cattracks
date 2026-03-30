Rails.application.routes.draw do
  root "posts#index"
  resource :session
  resources :passwords, param: :token
  resources :users, only: [:new, :create, :show]
  resource :profile, only: [:show, :edit, :update, :destroy]
  resources :cats do
    member do
      post :claim
      delete :leave
    end
    resources :sightings, only: [:new, :create, :destroy, :show, :edit, :update]
  end
  resources :posts, only: [:index, :show, :new, :create, :destroy]
end
