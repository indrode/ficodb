$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require "rvm/capistrano"

set :application, "ficodb"
set :default_stage, "staging"
set :stages, %w(production staging testing)
set :scm, :git
set :repository,  "git@github.com:indrode/ficodb.git"
set :user, "francis"
set :use_sudo, false
set :port, 52520
set :deploy_via, :remote_cache
set :template_dir, "config/deploy"
set :rvm_ruby_string, '1.9.2@rails3'

namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f ~/ficodb/shared/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:finalize_update", "db:db_config"

namespace :assets do
  task :precompile, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end

  task :cleanup, :roles => :web do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:clean"
  end
end

namespace :deploy do
  task :bundle_gems do
    run "cd #{deploy_to}/current && RAILS_ENV=#{rails_env} bundle install --path vendor/gems"
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && RAILS_ENV=#{rails_env} bundle exec thin restart  -s#{num_instances} -p #{thin_port}"
  end
end

after :deploy, "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:restart"
after :deploy, "assets:precompile"
