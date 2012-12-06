WhosUsingWhatWeb::Application.routes.draw do
    resources :companies
    root :to => "companies#index"

    match 'company/create', :to => 'companies#create'
  end