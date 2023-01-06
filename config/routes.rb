Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      post :authenticate, to: 'accounts#authenticate'
    end
  end
end
