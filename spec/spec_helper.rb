require 'rubygems'
ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

require File.join(File.dirname(__FILE__), '..', '..', 'moonshine', 'lib', 'moonshine.rb')
require File.join(File.dirname(__FILE__), '..', 'lib', 'astrails_safe.rb')
require File.join(File.dirname(__FILE__), '..', 'lib', 'php.rb')
require File.join(File.dirname(__FILE__), '..', 'lib', 'phpmyadmin.rb')
require File.join(File.dirname(__FILE__), '..', 'lib', 'tools.rb')
require File.join(File.dirname(__FILE__), '..', 'lib', 'webmin.rb')
require File.join(File.dirname(__FILE__), '..', 'lib', 'radiant.rb')

require 'shadow_puppet/test'