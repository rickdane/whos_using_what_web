WhosUsingWhatWeb::Application.routes.draw do

  resources :anewtables


  resources :somethings


  resources :person_searches
  resources :company_searches
  resources :whos_using_what

  resources :searches
  resources :calculator

  #this is way to limit to only GET, POST, etc for specific controller methods
=begin
  resources :searches, :collection => {
       :search => :post
  }
=end

  resources :sessions

  ENV['home_url'] = "/"

  match 'company_search/search', :to => 'company_searches#search'

  #this is for oauth re-routing
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  match '/loginstatus', :to => 'sessions#loginstatus'

  match 'people/search', :to => 'searches#search'
  match 'login', :to => 'sessions#create'
  match 'logout', :to => 'sessions#destroy'

  match 'authenticate', :to => 'sessions#new'

  #map.connect 'searches/calculator', :controller => 'searches', :action => 'calculator'

  root :to => "searches#new"


end
