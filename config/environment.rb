# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml', :version => '~> 2.0'
  config.gem 'jnunemaker-twitter', :lib => 'twitter', :version => '>= 0.6.12'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :version => '>= 2.3.11'
  config.gem 'javan-whenever', :lib => false, :version => '>= 0.3.5'
  config.time_zone = 'UTC'
end
