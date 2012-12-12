WhosUsingWhatWeb::Application.routes.draw do

  devise_for :users

  resources :searches
  resources :sessions

  ENV['home_url']  = "/"

  #this is for oauth re-routing
  match '/auth/:provider/callback', :to=> 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  match '/loginstatus', :to => 'sessions#loginstatus'

  match 'people/search', :to => 'searches#new'
  match 'login', :to => 'sessions#create'
  match 'logout', :to => 'sessions#destroy'

  match 'authenticate', :to => 'sessions#new'

  root :to => "searches#new"
  root :to => redirect("/users/login")

  devise_for :users, :path => '', :path_names => {:sign_in => 'authenticate', :sign_out => 'logout'}

end