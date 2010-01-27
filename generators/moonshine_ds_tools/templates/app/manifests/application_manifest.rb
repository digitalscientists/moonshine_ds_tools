require "#{File.dirname(__FILE__)}/../../vendor/plugins/moonshine/lib/moonshine.rb"

class ApplicationManifest < Moonshine::Manifest::Rails
  # ds defaults
  case deploy_stage
    when "production" then
      configure({
        :deploy_to => "", # /var/www/example.com
        :application =>  "",  # example.com
        :domain => "",  # example.com
        #:domain_aliases => [ "" ],  # www.example.com, example2.com
        :rails_env => "production"
      })
    when "staging" then 
      configure({
        :deploy_to => "", # /var/www/staging.example.com
        :application  => "",  # staging.example.com
        :domain => "",  # staging.example.com
        #:domain_aliases => [ "" ],  # 172.16.158.131
        :rails_env => "staging"
      })    
  end

  recipe :default_stack

  plugin :ds_tools
  configure(:phpmyadmin => {
    :only_on_stages => ['production'] #use this if staging and production are on the same box
  })
  recipe :default_ds_tools

  configure(:ssh  => {
    :port  => "30306",
    :allow_users => [configuration[:user]]  
  })
  plugin :ssh
  recipe :ssh

  configure(:iptables => { :rules => [
    '-A INPUT -i lo -j ACCEPT',  #  Allows all loopback (lo0) traffic and drop all traffic to 127/8 that doesn't use lo0
    '-A INPUT -i ! lo -d 127.0.0.0/8 -j REJECT',
    '-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT', #  Accepts all established inbound connections
    '-A OUTPUT -j ACCEPT', #  Allows all outbound traffic
    '-A INPUT -p tcp --dport 80 -j ACCEPT', # Allows HTTP and HTTPS connections from anywhere (the normal ports for websites)
    '-A INPUT -p tcp --dport 443 -j ACCEPT',
    '-A INPUT -p tcp -m tcp --dport 10000 -j ACCEPT', # webmin
    '-A INPUT -p tcp -m state --state NEW --dport 30306 -j ACCEPT', # Allows SSH connections
    '-A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT', # Allow ping
    '-A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7', # log iptables denied calls
    '-A INPUT -j REJECT', # Reject all other inbound - default deny unless explicitly allowed policy
    '-A FORWARD -j REJECT'] })
  plugin :iptables
  recipe :iptables
  # end ds defaults
  
  # Add your application's custom requirements here
  def application_packages
    # If you've already told Moonshine about a package required by a gem with
    # :apt_gems in <tt>moonshine.yml</tt> you do not need to include it here.
    # package 'some_native_package', :ensure => :installed
    
    # some_rake_task = "/usr/bin/rake -f #{configuration[:deploy_to]}/current/Rakefile custom:task RAILS_ENV=#{ENV['RAILS_ENV']}"
    # cron 'custom:task', :command => some_rake_task, :user => configuration[:user], :minute => 0, :hour => 0
   
    cron "#{deploy_stage}_daily_backup",
       :command => "astrails-safe #{configuration[:deploy_to]}/current/config/astrails_safe_backup_#{deploy_stage}.conf",
       :user => configuration[:user],
       :minute => "0",
       :hour => "0"
    
    # %w( root rails ).each do |user|
    #   mailalias user, :recipient => 'you@domain.com'
    # end
    
    # farm_config = <<-CONFIG
    #   MOOCOWS = 3
    #   HORSIES = 10
    # CONFIG
    # file '/etc/farm.conf', :ensure => :present, :content => farm_config
    
    # Logs for Rails, MySQL, and Apache are rotated by default
    # logrotate '/var/log/some_service.log', :options => %w(weekly missingok compress), :postrotate => '/etc/init.d/some_service restart'
    
    # Only run the following on the 'testing' stage using capistrano-ext's multistage functionality.
    # on_stage 'testing' do
    #   file '/etc/motd', :ensure => :file, :content => "Welcome to the TEST server!"
    # end
  end
  # The following line includes the 'application_packages' recipe defined above
  recipe :application_packages
end