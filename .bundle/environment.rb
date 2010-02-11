require 'digest/sha1'

# DO NOT MODIFY THIS FILE

module Bundler
  module SharedHelpers

    def reverse_rubygems_kernel_mixin
      require "rubygems"

      # Disable rubygems' gem activation system
      ::Kernel.class_eval do
        if private_method_defined?(:gem_original_require)
          alias rubygems_require require
          alias require gem_original_require
        end

        undef gem
      end
    end

    def default_gemfile
      gemfile = find_gemfile
      gemfile or raise GemfileNotFound, "The default Gemfile was not found"
      Pathname.new(gemfile)
    end

    def in_bundle?
      find_gemfile
    end

  private

    def find_gemfile
      return ENV['BUNDLE_GEMFILE'] if ENV['BUNDLE_GEMFILE']

      previous = nil
      current  = File.expand_path(Dir.pwd)

      until !File.directory?(current) || current == previous
        filename = File.join(current, 'Gemfile')
        return filename if File.file?(filename)
        current, previous = File.expand_path("#{current}/.."), current
      end
    end

    extend self
  end
end

module Bundler
  extend SharedHelpers

  reverse_rubygems_kernel_mixin

  FINGERPRINT = "bb24b2fc81742ef88ff61168f8ebef8ef1510b95"
  LOAD_PATHS = ["/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/builder-2.1.2/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/activesupport-2.3.5/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/text-hyphen-1.0.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/i18n-0.3.3/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/email_spec-0.4.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/pickle-0.2.1/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/json_pure-1.2.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/bundler-0.9.4/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/settingslogic-2.0.5/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/factory_girl-1.2.3/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/will_paginate-2.3.12/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/json-1.2.0/ext/json/ext", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/json-1.2.0/ext", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/json-1.2.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/cucumber-rails-0.2.4/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/formtastic-0.9.7/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/database_cleaner-0.4.3/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/rubyforge-2.0.3/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/ruby-hmac-0.4.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/mime-types-1.16/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/crack-0.1.6/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/tmail-1.2.7.1/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/tmail-1.2.7.1/ext/tmailscanner", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/whenever-0.4.1/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/delayed_job-1.8.4/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/hashie-0.1.8/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/oauth-0.3.6/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/polyglot-0.2.9/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/treetop-1.4.3/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/diff-lcs-1.1.2/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/rspec-1.3.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/remarkable-3.1.12/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/culerity-0.2.8/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/remarkable_activerecord-3.1.12/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/rspec-rails-1.3.2/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/remarkable_rails-3.1.12/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/selenium-webdriver-0.0.16/common/src/rb/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/selenium-webdriver-0.0.16/firefox/src/rb/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/selenium-webdriver-0.0.16/chrome/src/rb/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/selenium-webdriver-0.0.16/jobbie/src/rb/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/selenium-webdriver-0.0.16/remote/client/src/rb/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/rake-0.8.7/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/ffi-0.6.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/ffi-0.6.0/ext", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/gemcutter-0.3.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/hoe-2.5.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/nokogiri-1.4.1/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/nokogiri-1.4.1/ext", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/chronic-0.2.3/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/mysql-2.8.1/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/mysql-2.8.1/ext", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/haml-2.2.19/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/authlogic-2.1.3/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/memcache-client-1.7.8/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/rack-1.0.1/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/rack-test-0.5.3/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/capybara-0.3.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/actionpack-2.3.5/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/actionmailer-2.3.5/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/text-format-1.0.0/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/httparty-0.4.5/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/activerecord-2.3.5/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/searchlogic-2.4.10/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/term-ansicolor-1.0.4/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/cucumber-0.6.2/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/fakeweb-1.2.8/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/twitter-0.8.3/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/tzinfo-0.3.16/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/activeresource-2.3.5/lib", "/Volumes/SLHomes/piki/Projects/brandizzle/vendor/bundler_gems/gems/rails-2.3.5/lib"]
  AUTOREQUIRES = {:test=>["rspec", "rspec-rails", "remarkable_rails", "factory_girl", "fakeweb"], :default=>["haml", "twitter", "will_paginate", "whenever", "json", "searchlogic", "authlogic", "formtastic", "delayed_job", "settingslogic"], :rails=>["rails", "rack", "bundler", "rake", "builder", "memcache-client", "tzinfo", "i18n", "tmail", "text/format", "mysql"], :cucumber=>["cucumber-rails", "database_cleaner", "capybara", "rspec", "rspec-rails", "factory_girl", "pickle", "email_spec"]}

  def self.match_fingerprint
    print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))
    unless print == FINGERPRINT
      abort 'Gemfile changed since you last locked. Please `bundle lock` to relock.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    LOAD_PATHS.each { |path| $LOAD_PATH.unshift path }
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group] || []).each { |file| Kernel.require file }
    end
  end

  # Setup bundle when it's required.
  setup
end
