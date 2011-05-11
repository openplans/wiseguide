#-----Get Capistrano working with RVM-----
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"  # Load RVM's capistrano plugin.    
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user  # Don't use system-wide RVM
#---------------------------------------------

#-----Get Capistrano working with Bundler-----
require 'bundler/capistrano'
#---------------------------------------------

#-----Basic Recipe-----
set :application, "WiseGuide"
set :repository,  "http://github.com/openplans/wiseguide.git"
set :deploy_to, "/home/deployer/rails/wiseguide"

set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache

set :user, "deployer"  # The server's user for deployments
set :use_sudo, false

role :web, "184.154.79.122"
role :app, "184.154.79.122"
role :db,  "184.154.79.122", :primary => true # This is where Rails migrations will run

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :link_database_yml do
  puts "    (Link in database.yml file)"
  run  "ln -nfs #{deploy_to}/shared/config/database.yml #{deploy_to}/current/config/database.yml"
end

after "deploy:symlink", :link_database_yml
