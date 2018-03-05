Rails.application.routes.draw do
  devise_for :users

  get 'test_components', to: 'pages#test_components'

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
