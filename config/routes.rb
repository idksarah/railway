Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'pages#home'
  # root 'drawings#index'
  get 'pages/home'
  get 'wakatime', to: 'pages#wakatime', as: :wakatime
  get 'github', to: 'pages#github', as: :github
  get 'create_rails', to: 'pages#create_rails', as: :create_rails
  get 'deploy_rails', to: 'pages#deploy_rails', as: :deploy_rails
  resources :drawings
  get '/auth/:provider/callback', to: 'sessions#create', as: :slack_openid

  get '/auth/slack', to: 'sessions#new'
  get '/auth/slack/callback', to: 'drawings#new', as: :slack_callback
  get '/auth/failure', to: 'sessions#failure'
  delete '/logout', to: 'sessions#destroy', as: :logout
  get '/proxy_image', to: 'proxy#image'
end
