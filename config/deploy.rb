require 'capistrano/ext/multistage'
require File.dirname(__FILE__) + '/capistrano_database.rb'

set :application, "ficodb"
set :default_stage, "staging"
set :stages, %w(production staging testing)
set :scm, :git
set :repository,  "git@github.com:indrode/ficodb.git"
set :user, "francis"
set :use_sudo, false
set :port, 52520
set :deploy_via, :remote_cache

namespace :assets do
  task :precompile, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:precompile"
  end

  task :cleanup, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:clean"
  end
end

namespace :deploy do
  task :bundle_gems do
    run "cd #{deploy_to}/current && bundle install --path vendor/gems"
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && thin start --servers 3"
  end
end

after :deploy, "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:restart"
after :deploy, "assets:precompile"
