WhosUsingWhatWeb::Application.routes.draw do
    resources :companies
    root :to => "companies#index"
  end