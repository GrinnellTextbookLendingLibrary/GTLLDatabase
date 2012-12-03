Gtll::Application.routes.draw do

  get "sessions/new"

  resources :managers
  resources :sessions, :only => [:new, :create, :destroy]

  resources :books do
    collection do
      get 'search'
    end
  end

  resources :books do
    member do
      put 'checkin'
      put 'checkout'
      put 'update'
    end
  end

  get "books/new"

  root :to => 'pages#home'
  match '/index', :to => 'books#index'
  match '/signup', :to => 'managers#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
 
end
