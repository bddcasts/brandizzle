ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'cucumber/rails/rspec'
require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'

require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
require 'cucumber/rails/capybara_javascript_emulation' # Lets you click links with onclick javascript handlers without using @culerity or @javascript

Capybara.default_selector = :css
Capybara.javascript_driver = :selenium
ActionController::Base.allow_rescue = false
Cucumber::Rails::World.use_transactional_fixtures = true

World(Authlogic::TestCase)

Before do
  activate_authlogic
end

After do |scenario|
  if(scenario.failed?)
    save_and_open_page
  end
end

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

require 'features/support/pickle'
require 'email_spec'
require 'email_spec/cucumber'
require 'factory_girl'
require 'pickle'
require File.dirname(__FILE__) + '/../../spec/factories'
World(ActionView::Helpers::RecordIdentificationHelper)