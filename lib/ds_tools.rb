module DsTools
  def default_ds_tools
    self.class.recipe :astrails_safe, :php, :phpmyadmin, :webmin, :tools, :tools_apache
  end
end