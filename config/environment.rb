# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml',                                    :version => '~> 2.2'
  config.gem 'twitter',       :lib => 'twitter',        :version => '>= 0.8.0'
  config.gem 'will_paginate', :lib => 'will_paginate',  :version => '>= 2.3.11'
  config.gem 'whenever',      :lib => false,            :version => '>= 0.4.1'
  config.gem 'json',                                    :version => '>= 1.2.0'
  config.gem 'searchlogic',                             :version => '>= 2.4.7'
  config.gem 'authlogic',                               :version => '>= 2.1.3'
  config.gem 'formtastic',                              :version => '>= 0.9.7'
  config.time_zone = 'UTC'
end

require 'open-uri'