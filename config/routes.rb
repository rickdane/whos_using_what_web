WhosUsingWhatWeb::Application.routes.draw do
    resources :companies
    root :to => "home#index"

    get "companies" => "companies#index"
  end