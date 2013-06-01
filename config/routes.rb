Gtll::Application.routes.draw do

  root :to => 'pages#home'

  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :checkout_records

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

  match '/records', :to => 'books#records'
  match '/index', :to => 'books#index'
  match '/signup', :to => 'users#new'
  match '/emails', :to => 'users#all_user_emails'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/borrowers', :to => 'checkout_records#checked_out_users_list'

  match '/images/logo600', :to => 'public#logo600.png'
 
  match '/checkoutProcedure', :to => 'pages#checkoutProcedure'
  match '/notes', :to => 'pages#website_notes'

  match '/sampleCheckoutForm', :to => 'pages#sampleCheckoutForm.pdf'
  match '/searchInfo', :to => 'pages#searchInfo'
end
