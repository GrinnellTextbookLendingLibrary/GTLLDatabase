Gtll::Application.routes.draw do

  root :to => 'pages#home'

  resources :managers
  resources :sessions, :only => [:new, :create, :destroy]

  resources :books do
    collection do
      get 'search'
    end
    member do
      put 'checkin'
      put 'checkout'
      put 'set_total_num_copies'
    end
  end

  match '/index', :to => 'books#index'
  match '/signup', :to => 'managers#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match '/images/logo600', :to => 'public#logo600.png'
 
  match '/checkoutProcedure', :to => 'pages#checkoutProcedure'
  match '/sampleCheckoutForm', :to => 'public#sampleCheckoutForm.pdf'
  match '/searchInfo', :to => 'pages#searchInfo'

end
