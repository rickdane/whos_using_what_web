WhosUsingWhatWeb::Application.routes.draw do

  devise_for :users

  resources :searches
  resources :sessions

  root :to => "searches#new"

  ENV['home_url']  = "/"

  #this is for oauth re-routing
  match '/auth/:provider/callback', :to=> 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  match '/loginstatus', :to => 'sessions#loginstatus'

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