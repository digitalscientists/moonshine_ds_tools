server "", :app, :web, :db, :primary => true  # ip or domain of staging box
set :deploy_to, "" # /var/www/example.com

set :branch, "master"
set :rails_env, "production"