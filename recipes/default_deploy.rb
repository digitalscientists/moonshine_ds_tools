unless (fetch(:apply_default_deploy, false))
  set :port, ENV['PORT'] || "30306"

  # Set local ssh key to ds identity file
  ds_key_directory = File.join(ENV['HOME'], '.dotfiles', 'ssh', 'keys')
  if File.exists?(ds_key_directory)
    ds_ssh_key = File.join(ds_key_directory, "digitalscientists")
    ssh_options[:keys] = [ds_ssh_key] unless ENV['USE_PASSWORD']
  end

  unless (fetch(:disable_moonshine, false) && ENV['moonshine_apply'] != 'true')
    set :moonshine_apply, false

    before 'deploy:symlink' do
      run "cd #{latest_release} && RAILS_ENV=#{fetch(:rails_env, 'production')} rake db:migrate"
    end

    namespace :deploy do
      desc "Restart the Passenger processes on the app server by touching tmp/restart.txt."
      task :restart, :roles => :app, :except => { :no_release => true } do
        run "touch #{current_path}/tmp/restart.txt"
      end
    end
  end
end