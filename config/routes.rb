Rails.application.routes.draw do
  root "offers#index"

  get 'offers/list', to: 'offers#list'
  get 'orders/payment-methods', to: 'orders#get_payment_methods'
  resources :offers, only: :index
  resources :orders, only: :create,
    defaults: { format: :json }, constraints: { format: :json }
end
