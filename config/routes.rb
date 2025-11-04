Rails.application.routes.draw do
  get "notifications/index"
  devise_for :users, path: "", path_names: {
    sign_up: "register",
    sign_in: "login",
    sign_out: "logout"
  }, controllers: {
    confirmations: "users/confirmations"
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :users

  resources :bulletin_posts

  resources :projects do
    member do
      patch :close
      patch :reopen
    end
    resources :memberships, only: [ :create, :destroy ]
  end

  resources :teaching_offers do
    resources :memberships, only: [ :create, :destroy, :index ] do
      member do
        patch :approve
        patch :reject
      end
    end
  end

  resources :notifications, only: [:index] do
    patch :toggle_email, on: :collection
  end

  get "/account", to: "users#account", as: "account"

  root "bulletin_posts#index"
  resources :bulletin_posts, only: [ :index, :show, :new, :create, :edit, :update, :destroy ]
end
