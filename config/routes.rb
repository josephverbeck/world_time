Rails.application.routes.draw do

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get    '/signup',  to: 'users#new'

  root :to => 'sessions#new'

  resources :addresses
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
