Rails.application.routes.draw do

  devise_for :users
  resources :users, only: [:index, :show]
  resources :tasks, except: [:new, :show, :edit]

  resources :approvements, only: :create
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"

end
