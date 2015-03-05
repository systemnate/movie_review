Rails.application.routes.draw do
  # Root to show all movies
  root 'movies#index'
  # Static pages
  get '/about', to: 'pages_controller#about'
  get '/sitemap.xml', to: 'pages_controller#sitemap'
  get '/google8cbf67f657da8a59.html', to: 'pages_controller#google'
  get '/fresh', to: 'movies#fresh'
  # Devise / OmniAuth
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  #devise_scope :user do
  #  get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  #end
  # Resources
  resources :movies do
    collection do
      get 'search'
    end
    resources :reviews, except: [:show, :index]
    member do
      put "like", to: "movies#upvote"
      put "dislike", to: "movies#downvote"
    end
  end
  # API
  namespace :api do
    resources :movies
  end
end