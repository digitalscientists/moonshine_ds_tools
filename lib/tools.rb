module Tools

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:tools => {:foo => true})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :ds_tools
  #  recipe :tools
  def tools(options = {})
    # define the recipe
    # options specified with the configure method will be 
    # automatically available here in the options hash.
    #    options[:foo]   # => true
  end

  def tools_apache(options = {})
    # Build httpd.conf file
    file '/etc/apache2/httpd.conf',
      :ensure => :present,
      :content => template(File.join(File.dirname(__FILE__), 'templates', 'httpd.conf.erb')),
      :notify => service("apache2"),
      :alias => "httpd_conf"
  end
  
end