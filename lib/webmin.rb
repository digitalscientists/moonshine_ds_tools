module Webmin

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:webmin => {:foo => true})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :ds_tools
  #  recipe :webmin
  def webmin(options = {})
    # define the recipe
    # options specified with the configure method will be 
    # automatically available here in the options hash.
    #    options[:foo]   # => true
    
    package "perl", :ensure => :installed
    package "libnet-ssleay-perl", :ensure => :installed
    package "openssl", :ensure => :installed
    package "libauthen-pam-perl", :ensure => :installed
    package "libpam-runtime", :ensure => :installed
    package "libio-pty-perl", :ensure => :installed
    package "libmd5-perl", :ensure => :installed

    @webmin_install_script = %{sudo mkdir -p /tmp/webmin_src
cd /tmp/webmin_src
sudo wget http://prdownloads.sourceforge.net/webadmin/webmin_1.480_all.deb
sudo dpkg --install webmin_1.480_all.deb
}

    exec "webmin_install",
      :command => @webmin_install_script,
      :unless =>  "ls /usr/share/ | grep webmin"
  end
  
end