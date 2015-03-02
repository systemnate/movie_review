Rails.application.routes.draw do
  
  get '/about', to: 'pages_controller#about'
  get '/sitemap.xml', to: 'pages_controller#sitemap'
  get '/google8cbf67f657da8a59.html', to: 'pages_controller#google'
  devise_for :users
  
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
  
  root 'movies#index'

end