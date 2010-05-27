# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require 'remarkable_rails'
require 'factory_girl'
require 'authlogic/test_case'
require "database_cleaner"

Dir[File.expand_path(File.join(File.dirname(__FILE__), '/factories', '*.rb'))].each {|f| require f}
# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  include Authlogic::TestCase
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
  
  DatabaseCleaner.clean_with(:truncation)
  
  config.before(:each) do
    activate_authlogic
  end

  def current_user(stubs = {})
    @current_user ||= stub_model(User, stubs)
  end

  def user_session(stubs = {}, user_stubs = {})
    @current_user_session ||= mock_model(UserSession, {:record => current_user(user_stubs)}.merge(stubs))
  end

  def login_user(session_stubs = {}, user_stubs = {})
    UserSession.stub!(:find).and_return(user_session(session_stubs, user_stubs))
  end

  def logout_user
    @current_user_session = nil
  end
end
