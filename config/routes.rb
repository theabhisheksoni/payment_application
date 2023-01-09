Rails.application.routes.draw do
  root to: 'home#index'
  resources :merchants, except: :create
  devise_for :users
  namespace :api do
    namespace :v1 do
      resources :transactions, only: :create do
        member do
          put :charge_transaction
          put :refund_transaction
          put :reversal_transaction
        end
      end
      post :authenticate, to: 'accounts#authenticate'
    end
  end
end
