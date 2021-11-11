Rails.application.routes.draw do
  resources :results
  resources :groups
  resources :runners
  resources :competitions
  resources :categories
  resources :clubs
  root to: 'home#index'
  get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
