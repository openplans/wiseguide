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
    collection do
      get  :search
      post :add_impairment
      post :delete_impairment
    end
    
    member do
      get :download_original_portrait
      get :download_small_portrait
    end
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
    get "new_survey", :on=>:collection
    put "new_survey", :on=>:collection, :to=>"surveyor#create_survey", :as=>:new_survey
    post "reactivate_survey", :to=>"surveyor#reactivate", :as=>:reactivate
  end

  resources :outcomes

  devise_for :users, :controllers=>{:sessions=>"users"} do
    get "new_user" => "users#new_user"
    post "create_user" => "users#create_user"
    put "create_user" => "users#create_user"
    get "init" => "users#show_init"
    post "logout" => "users#sign_out"
    post "init" => "users#init"
    post "update_user" => "users#update"
    delete "user" => "users#delete"
    get "show_change_password" => "users#show_change_password"
    match "change_password"  => "users#change_password"

  end

  match 'users', :controller=>:admin, :action=>:users
  match 'admin', :controller=>:admin, :action=>:index

  match 'reports(/:action)', :controller=>:reports

  match "test_exception_notification" => "application#test_exception_notification"

  root :to => "home#index"
end
