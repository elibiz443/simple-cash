Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
      resources :top_ups
      resources :transactions
      resources :reports
      get "/notifications", to: "transactions#get_notifications"
      get "/notifications/:id", to: "transactions#get_notification"
      patch "/notifications/:id", to: "transactions#update_notification_status"
      delete "/notifications/:id", to: "transactions#delete_notification"
    end
  end
end
