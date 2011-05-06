Wiseguide::Application.routes.draw do
  resources :trip_reasons

  resources :routes

  resources :referral_types

  resources :impairments

  resources :funding_sources

  resources :event_types

  resources :ethnicities

  resources :dispositions

  resources :customer_support_network_members

  resources :customers do
    post "add_impairment", :on=>:collection
    post "delete_impairment", :on=>:collection
  end

  resources :kases, :path => "cases" do 
    post "add_route", :on=>:collection
    post "delete_route", :on=>:collection
  end

  resources :contacts

  resources :events

  #these are called "assessments" in user-visible text
  resources :surveys, :controller=>'Surveyor' do
    delete "/:survey_code/:response_set_code/delete", :to => "surveyor#delete_response_set", :as=>:delete, :on=>:collection
  end

  resources :outcomes

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
  match 'admin', :controller=>:admin, :action=>:index

  root :to => "home#index"
end
