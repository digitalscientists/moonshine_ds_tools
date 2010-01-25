module Phpmyadmin

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:phpmyadmin => {
  #       :domain => "phpmyadmin.server.com",   # url for to access phpmyadmin, defaults to db.<yourdomain>.com
  #       :only_on_stages => ['production']     # stages you want phpmyadmin setup, defaults to all
  #    })
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :ds_tools
  #  recipe :phpmyadmin
  
  def phpmyadmin(options = {})
    @phpmyadmin_domain = options[:domain] || "db.#{configuration[:domain]}"
    @only_on_stages = options[:only_on_stages] || false

    package "phpmyadmin", :ensure => :installed
        
    if @only_on_stages
      @only_on_stages.each do |stage|
        if deploy_stage == stage
          create_phpmyadmin_vhost
        end
      end
    else
      create_phpmyadmin_vhost
    end
        
    file '/etc/phpmyadmin/config.inc.php',
      :ensure => :present,
      :content => template(File.join(File.dirname(__FILE__), 'templates', 'config.inc.php.erb')),
      :notify => service("apache2"),
      :alias => "phpmyadmin_config"    
  end
  
  private

  def create_phpmyadmin_vhost
    file "/etc/apache2/sites-available/#{@phpmyadmin_domain}",
      :ensure => :present,
      :content => template(File.join(File.dirname(__FILE__), 'templates', 'phpmyadmin.vhost.erb')),
      :notify => service("apache2"),
      :require => exec("a2enmod passenger"),
      :alias => "phpmyadmin_vhost"

      a2ensite @phpmyadmin_domain, :require => file("phpmyadmin_vhost")    
  end
end