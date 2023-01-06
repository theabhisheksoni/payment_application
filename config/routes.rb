Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  namespace :api do
    namespace :v1 do
      post :authenticate, to: 'accounts#authenticate'
    end
  end
end
