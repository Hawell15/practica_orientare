Rails.application.routes.draw do
  devise_for :users
  resources :results
  resources :groups
  resources :runners
  resources :competitions
  resources :categories
  resources :clubs
  root to: 'home#index'
  get 'home/index'
  get 'home/add_competition_file', as: "competition_file"
  post 'home/add_competition_file', as: "competition_file_post"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
