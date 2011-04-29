Wiseguide::Application.routes.draw do
  resources :trip_reasons

  resources :routes

  resources :referral_types

  resources :impairments

  resources :funding_sources

  resources :event_types

  resources :eventtypes

  resources :ethnicities

  resources :dispositions

  devise_for :users, :controllers=>{:sessions=>"users"} do
    get "new_user" => "users#new_user"
    post "create_user" => "users#create_user"
    put "create_user" => "users#create_user"
    get "init" => "users#show_init"
    post "init" => "users#init"
    post "update_user" => "users#update"
    delete "user" => "users#delete"
  end

  match 'users', :controller=>:admin, :action=>:users

  root :to => "home#index"
end
