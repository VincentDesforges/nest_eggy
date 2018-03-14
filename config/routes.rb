Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  get 'test_components', to: 'pages#test_components'
  get "transaction_history", as: "th", to: 'pages#transaction_history'
  get "savings", as: "svg", to: 'pages#savings'
  get "breakdown", as: "brd", to: 'pages#breakdown'
  get "stocks", as: "stks", to: 'pages#stocks'


  resources :plans, only: [ :new, :create, :index, :show ]

  get "bank_accounts/bankin", as: "bankin", to: 'bank_accounts#bankin'
  resources :bank_accounts, only: [ :new, :create ]

  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
