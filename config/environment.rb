# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  
  config.after_initialize do
    ActionMailer::Base.default_url_options[:host] = Settings.host
    
    Braintree::Configuration.environment = Settings.braintree.environment
    Braintree::Configuration.merchant_id = Settings.braintree.merchant_id
    Braintree::Configuration.public_key  = Settings.braintree.public_key
    Braintree::Configuration.private_key = Settings.braintree.private_key
  end
end

require 'open-uri'
require 'duck_punches/string'
