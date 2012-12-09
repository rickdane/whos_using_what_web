WhosUsingWhatWeb::Application.routes.draw do

  devise_for :users

  resources :companies
  resources :searches
  resources :sessions

  root :to => "searches#new"

  #this is for oauth re-routing
  match '/auth/:provider/callback', :to=> 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'


  match 'company/create', :to => 'companies#create'
  match 'people/search', :to => 'searches#new'
  match 'login', :to => 'sessions#create'
  match 'logout', :to => 'sessions#destroy'

  devise_for :users,
             :as => '',
             :path_names => {
                 :sign_in => "/sessions/new",
                 :sign_out => "logout",
                 :sign_up => "register"
             }

end