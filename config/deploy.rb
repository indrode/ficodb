require 'capistrano/ext/multistage'

set :application, "ficodb"
set :repository,  "git@github.com:indrode/ficodb.git"

set :default_stage, "staging"
set :stages, %w(production staging testing)

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "francis"
set :use_sudo, false
set :port, 52520
set :deploy_via, :remote_cache

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

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
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after :deploy, "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:restart"
after :deploy, "assets:precompile"
