Rails.application.routes.draw do
  devise_for :users

  get 'test_components', to: 'pages#test_components'
  get "users/:id/transaction_history", as: "th", to: 'pages#transaction_history'
  get "users/:id/savings", as: "svg", to: 'pages#savings'
  get "users/:id/breakdown", as: "brd", to: 'pages#breakdown'

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
