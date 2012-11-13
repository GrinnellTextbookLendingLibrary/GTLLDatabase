Gtll::Application.routes.draw do

  resources :managers

  resources :books do
    collection do
      get 'search'
    end
  end

  get "books/new"

  root :to => 'pages#home'
  match '/index', :to => 'books#index'
  match '/signup', :to => 'managers#new'

 
end
