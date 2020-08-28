Rails.application.routes.draw do
  root "offers#index"

  resources :offers, only: :index
  resources :orders, only: :create,
    defaults: { format: :json }, constraints: { format: :json }
end
