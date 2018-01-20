Rails.application.routes.draw do

  root :to => 'countries#index'

  resources :countries do
    resources :states
  end
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
