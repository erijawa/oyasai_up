Rails.application.routes.draw do
  root "static_pages#home"
  get "policy", to: "static_pages#policy"
  get "term", to: "static_pages#term"
  get "inquiry", to: "static_pages#inquiry"
  resources :users, only: %i[show edit update]
  resources :posts, only: %i[index new create show edit update destroy] do
    get "bookmarks", on: :collection
    get "drafts", on: :collection
  end
  resources :ai_recipes, only: %i[create]
  resources :bookmarks, only: %i[create destroy]
  resources :vegetable_logs, only: %i[create update]
  devise_for :users,
    path: "",
    path_names: {
      sign_up: "",
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
    },
    controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions",
      omniauth_callbacks: "users/omniauth_callbacks",
      passwords: "users/passwords"
  }
  post "/callback" => "linebots#callback"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
