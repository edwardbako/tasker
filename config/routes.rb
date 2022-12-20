Rails.application.routes.draw do
  resources :tasks, except: [:new, :show, :edit]
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"

end
