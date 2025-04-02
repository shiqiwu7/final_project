Rails.application.routes.draw do
  root "events#index"

  # Authentication routes
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Resources
  # resources :users, except: [ :index, :destroy ]
  resources :users, only: [:new, :create]

  resources :teams do
    member do
      post "join"
      delete "leave"
    end
  end

  resources :events do
    resources :participations, only: [ :create, :update, :destroy ]
    resources :results, except: [ :index, :show ]
  end

  # Player profile routes
  get "/profile", to: "users#show"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"

  # Organizer profile routes
  get "/organization", to: "users#show"
  get "/organization/edit", to: "users#edit"
  patch "/organization", to: "users#update"
end
