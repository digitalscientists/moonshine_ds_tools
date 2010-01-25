module DsThinkingSphinx

  # Define options for this plugin via the <tt>configure</tt> method
  # in your application manifest:
  #
  #   configure(:ds_thinking_sphinx => {:foo => true})
  #
  # Then include the plugin and call the recipe(s) you need:
  #
  #  plugin :ds_tools
  #  recipe :ds_thinking_sphinx, :ds_thinking_sphinx_gem

  def ds_thinking_sphinx(options = {})
    sphinx_download = "sphinx-0.9.9.tar.gz"
    @ds_thinking_sphinx_install_script = %{mkdir -p ~/src/sphinx
cd ~/src/sphinx
wget http://www.sphinxsearch.com/downloads/#{sphinx_download}
tar xzf #{sphinx_download}
cd #{sphinx_download.gsub(/\.tar\.gz/, '')}
./configure
make
sudo make install
cd ~
rm -rf ~/src/sphinx
}
    exec "think_sphinx_install",
      :command => @ds_thinking_sphinx_install_script,
      :unless =>  "ls /usr/local/bin/ | grep search && ls /usr/local/bin/ | grep searchd"
  end
  
  def ds_thinking_sphinx_gem
    exec "ds_thinking_sphinx_gem_install",
      :command => "sudo gem install thinking-sphinx", 
      :unless => "gem list | grep thinking-sphinx"
  end

end