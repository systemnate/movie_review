Rails.application.routes.draw do
  
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