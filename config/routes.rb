WhosUsingWhatWeb::Application.routes.draw do
  resources :tests


  get "sessions/new"
  get "sessions/create"
  get "sessions/failure"
  get "sessions/destroy"

  match '/auth/:provider/callback', :to => 'sessions#create'
  match '/auth/failure', :to => 'sessions#failure'

  resources :companies
  resources :tests
  root :to => "companies#index"

  match 'company/create', :to => 'companies#create'
  match 'people/search', :to => 'tests#search'
end