set :rails_env, "testing" 
role :web, "zenpunch.com"
role :app, "zenpunch.com"
role :db,  "zenpunch.com", :primary => true

set :deploy_to, "~/#{application}/testing"