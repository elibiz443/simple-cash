Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
      resources :top_ups
      resources :transactions
      resources :reports
    end
  end
end
