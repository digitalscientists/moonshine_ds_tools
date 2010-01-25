module AstrailsSafe

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:astrails_safe => {:foo => true})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :ds_tools
  #  recipe :astrails_safe
  def astrails_safe(options = {})
    # define the recipe
    # options specified with the configure method will be 
    # automatically available here in the options hash.
    #    options[:foo]   # => true

    gem "net-ssh", :ensure => :installed
    gem "net-sftp", :ensure => :installed
    gem "astrails-safe", :ensure => :installed

    file "#{configuration[:deploy_to]}/shared/config/astrails_safe_backup.conf",
      :ensure => :present,
      :content => template(File.join(File.dirname(__FILE__), 'templates', 'astrails_safe_backup.conf.erb')),
      :alias => "astrails"
    
  end
  
end