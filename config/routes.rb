Rails.application.routes.draw do
  devise_for :users

  get 'test_components', to: 'pages#test_components'
  get "users/:id/transaction_history", as: "th"
  get "users/:id/savings", as: "th"
  get "users/:id/breakdown", as: "th"

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
