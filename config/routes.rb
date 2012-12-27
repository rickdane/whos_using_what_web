WhosUsingWhatWeb::Application.routes.draw do

  resources :person_searches


  resources :searches
  resources :sessions

  ENV['home_url']  = "/"

  #this is for oauth re-routing
  match '/auth/:provider/callback', :to=> 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  match '/loginstatus', :to => 'sessions#loginstatus'

  match 'people/search', :to => 'searches#search'
  match 'login', :to => 'sessions#create'
  match 'logout', :to => 'sessions#destroy'

  match 'authenticate', :to => 'sessions#new'

  root :to => "searches#new"

end