Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'
  mount API::Base => '/api'
  mount GrapeSwaggerRails::Engine, at: "/documentation"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
  resources :ssh_keys
  resources :boxes do
    resources :components
  end
  
  devise_for :users

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for "User", at: 'auth'
    end
  end

  root 'home#index'
end
