Rails.application.routes.draw do
  get "sightings/new"
  get "sightings/create"
  get "sightings/destroy"
  get "posts/index"
  get "posts/show"
  get "posts/new"
  get "posts/create"
  get "posts/destroy"
  get "cats/index"
  get "cats/show"
  get "cats/new"
  get "cats/create"
  get "cats/edit"
  get "cats/update"
  get "cats/destroy"
  get "profiles/show"
  get "profiles/edit"
  get "profiles/update"
  get "profiles/destroy"
  get "home/index"
  resource :session
  resources :passwords, param: :token
end
