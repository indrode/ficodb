set :rails_env, "production"
set :num_instances, "3"
set :thin_port, "4000"
role :web, "zenpunch.com"
role :app, "zenpunch.com"
role :db,  "zenpunch.com", :primary => true

set :deploy_to, "~/#{application}/production"