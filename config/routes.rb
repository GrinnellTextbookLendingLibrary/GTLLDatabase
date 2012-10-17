Gtll::Application.routes.draw do
  resources :books

  get "books/new"

  root :to => 'pages#home'
  match '/index', :to => 'books#index'


 
end
