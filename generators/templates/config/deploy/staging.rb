server "", :app, :web, :db, :primary => true  # ip or domain of staging box
set :deploy_to, "" # /var/www/staging.example.com

set :branch, "staging"
set :rails_env, "staging"