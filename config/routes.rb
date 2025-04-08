Rails.application.routes.draw do
  devise_for :users
  root "events#index"

  # Authentication routes
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Resources
  # resources :users, except: [ :index, :destroy ]
  resources :users, only: [ :show, :new, :create ]

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

  # API routes
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post "auth/login", to: "auth#login"
        post "auth/register", to: "auth#register"
        delete "auth/logout", to: "auth#logout"
      end

      resources :events, only: [ :index, :show, :create, :update, :destroy ]
      resources :teams, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          post "join"
          delete "leave"
        end
      end
      resources :users, only: [ :show, :update ] do
      # Add the update_avatar route under the users resource
      collection do
        post "update_avatar", to: "users#update_avatar"
      end
    end
      resources :participations, only: [ :create, :update, :destroy ]
    end
  end
end
