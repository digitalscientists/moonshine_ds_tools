module Radiant

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:radiant => {:foo => true})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :ds_tools
  #  recipe :radiant
  def radiant(options = {})
    gem "radiant", :ensure => :installed
  end

  def radiant_migrations(options = {})
    @extensions = options[:extensions] || false
    
    if @extensions
      @extensions.each do |extension|
        if extension == 'all'
          rake 'db:migrate:extensions'
        else
          rake "radiant:extensions:#{extension}:migrate"
        end
      end
    else
      rake 'db:migrate:extensions'
    end
  end
  
end