Gtll::Application.routes.draw do
  get "managers/new"

  resources :books do
    collection do
      get 'search'
    end
  end

  get "books/new"

  root :to => 'pages#home'
  match '/index', :to => 'books#index'


 
end
