Wiseguide::Application.routes.draw do
  devise_for :users, :controllers=>{:sessions=>"users"} do
    get "new_user" => "users#new_user"
    post "create_user" => "users#create_user"
    put "create_user" => "users#create_user"
    get "init" => "users#show_init"
    post "init" => "users#init"
    post "change_provider" => "users#change_provider"
  end

  match 'users', :controller=>:users, :action=>:index
end
