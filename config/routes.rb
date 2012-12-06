WhosUsingWhatWeb::Application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/failure"
  get "sessions/destroy"

  get '/login', :to => 'sessions#new', :as => :login
  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  resources :companies
  resources :companies
  root :to => "companies#index"

  match 'company/create', :to => 'companies#create'
end