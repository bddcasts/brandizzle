# DO NOT MODIFY THIS FILE

require 'digest/sha1'
require 'rubygems'

module Gem
  class Dependency
    if !instance_methods.map { |m| m.to_s }.include?("requirement")
      def requirement
        version_requirements
      end
    end
  end
end

module Bundler
  module SharedHelpers

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
        current, previous = File.expand_path("..", current), current
      end
    end

    def clean_load_path
      # handle 1.9 where system gems are always on the load path
      if defined?(::Gem)
        me = File.expand_path("../../", __FILE__)
        $LOAD_PATH.reject! do |p|
          next if File.expand_path(p).include?(me)
          p != File.dirname(__FILE__) &&
            Gem.path.any? { |gp| p.include?(gp) }
        end
        $LOAD_PATH.uniq!
      end
    end

    def reverse_rubygems_kernel_mixin
      # Disable rubygems' gem activation system
      ::Kernel.class_eval do
        if private_method_defined?(:gem_original_require)
          alias rubygems_require require
          alias require gem_original_require
        end

        undef gem
      end
    end

    def cripple_rubygems(specs)
      reverse_rubygems_kernel_mixin

      executables = specs.map { |s| s.executables }.flatten

     :: Kernel.class_eval do
        private
        def gem(*) ; end
      end
      Gem.source_index # ensure RubyGems is fully loaded

      ::Kernel.send(:define_method, :gem) do |dep, *reqs|
        if executables.include? File.basename(caller.first.split(':').first)
          return
        end
        opts = reqs.last.is_a?(Hash) ? reqs.pop : {}

        unless dep.respond_to?(:name) && dep.respond_to?(:requirement)
          dep = Gem::Dependency.new(dep, reqs)
        end

        spec = specs.find  { |s| s.name == dep.name }

        if spec.nil?
          e = Gem::LoadError.new "#{dep.name} is not part of the bundle. Add it to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        elsif dep !~ spec
          e = Gem::LoadError.new "can't activate #{dep}, already activated #{spec.full_name}. " \
                                 "Make sure all dependencies are added to Gemfile."
          e.name = dep.name
          e.version_requirement = dep.requirement
          raise e
        end

        true
      end

      # === Following hacks are to improve on the generated bin wrappers ===

      # Yeah, talk about a hack
      source_index_class = (class << Gem::SourceIndex ; self ; end)
      source_index_class.send(:define_method, :from_gems_in) do |*args|
        source_index = Gem::SourceIndex.new
        source_index.spec_dirs = *args
        source_index.add_specs(*specs)
        source_index
      end

      # OMG more hacks
      gem_class = (class << Gem ; self ; end)
      gem_class.send(:define_method, :bin_path) do |name, *args|
        exec_name, *reqs = args

        spec = nil

        if exec_name
          spec = specs.find { |s| s.executables.include?(exec_name) }
          spec or raise Gem::Exception, "can't find executable #{exec_name}"
        else
          spec = specs.find  { |s| s.name == name }
          exec_name = spec.default_executable or raise Gem::Exception, "no default executable for #{spec.full_name}"
        end

        gem_bin = File.join(spec.full_gem_path, spec.bindir, exec_name)
        gem_from_path_bin = File.join(File.dirname(spec.loaded_from), spec.bindir, exec_name)
        File.exist?(gem_bin) ? gem_bin : gem_from_path_bin
      end
    end

    extend self
  end
end

module Bundler
  LOCKED_BY    = '0.9.13'
  FINGERPRINT  = "850d5a6504aa13d6270d5396cf023baaf9050a32"
  AUTOREQUIRES = {:test=>[["factory_girl", false], ["fakeweb", false], ["rspec", false], ["rspec-rails", false], ["remarkable_rails", false]], :default=>[["authlogic", false], ["haml", false], ["compass", false], ["delayed_job", false], ["formtastic", false], ["json", false], ["searchlogic", false], ["settingslogic", false], ["twitter", false], ["whenever", false], ["will_paginate", false]], :rails=>[["rake", false], ["rack", false], ["builder", false], ["bundler", false], ["i18n", false], ["memcache-client", false], ["mysql", false], ["rails", false], ["text/format", true], ["tmail", false], ["tzinfo", false]], :cucumber=>[["capybara", false], ["cucumber-rails", false], ["database_cleaner", false], ["email_spec", false], ["launchy", false], ["mongrel", false], ["pickle", false]]}
  SPECS        = [
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/rake-0.8.7/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/rake-0.8.7.gemspec", :name=>"rake"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/activesupport-2.3.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/activesupport-2.3.5.gemspec", :name=>"activesupport"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/rack-1.0.1/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/rack-1.0.1.gemspec", :name=>"rack"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/actionpack-2.3.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/actionpack-2.3.5.gemspec", :name=>"actionpack"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/actionmailer-2.3.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/actionmailer-2.3.5.gemspec", :name=>"actionmailer"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/activerecord-2.3.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/activerecord-2.3.5.gemspec", :name=>"activerecord"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/activeresource-2.3.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/activeresource-2.3.5.gemspec", :name=>"activeresource"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/authlogic-2.1.3/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/authlogic-2.1.3.gemspec", :name=>"authlogic"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/builder-2.1.2/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/builder-2.1.2.gemspec", :name=>"builder"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/bundler-0.9.13/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/bundler-0.9.13.gemspec", :name=>"bundler"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/culerity-0.2.9/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/culerity-0.2.9.gemspec", :name=>"culerity"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/mime-types-1.16/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/mime-types-1.16.gemspec", :name=>"mime-types"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/nokogiri-1.4.1/lib", "/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/nokogiri-1.4.1/ext"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/nokogiri-1.4.1.gemspec", :name=>"nokogiri"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/rack-test-0.5.3/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/rack-test-0.5.3.gemspec", :name=>"rack-test"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/ffi-0.6.3/lib", "/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/ffi-0.6.3/ext"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/ffi-0.6.3.gemspec", :name=>"ffi"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/json_pure-1.2.3/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/json_pure-1.2.3.gemspec", :name=>"json_pure"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/selenium-webdriver-0.0.17/common/src/rb/lib", "/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/selenium-webdriver-0.0.17/firefox/src/rb/lib", "/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/selenium-webdriver-0.0.17/chrome/src/rb/lib", "/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/selenium-webdriver-0.0.17/jobbie/src/rb/lib", "/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/selenium-webdriver-0.0.17/remote/client/src/rb/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/selenium-webdriver-0.0.17.gemspec", :name=>"selenium-webdriver"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/capybara-0.3.6/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/capybara-0.3.6.gemspec", :name=>"capybara"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/cgi_multipart_eof_fix-2.5.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/cgi_multipart_eof_fix-2.5.0.gemspec", :name=>"cgi_multipart_eof_fix"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/gemcutter-0.5.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/gemcutter-0.5.0.gemspec", :name=>"gemcutter"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/rubyforge-2.0.4/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/rubyforge-2.0.4.gemspec", :name=>"rubyforge"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/hoe-2.5.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/hoe-2.5.0.gemspec", :name=>"hoe"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/chronic-0.2.3/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/chronic-0.2.3.gemspec", :name=>"chronic"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/haml-2.2.19/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/haml-2.2.19.gemspec", :name=>"haml"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/compass-0.8.17/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/compass-0.8.17.gemspec", :name=>"compass"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/configuration-1.1.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/configuration-1.1.0.gemspec", :name=>"configuration"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/crack-0.1.7/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/crack-0.1.7.gemspec", :name=>"crack"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/diff-lcs-1.1.2/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/diff-lcs-1.1.2.gemspec", :name=>"diff-lcs"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/polyglot-0.3.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/polyglot-0.3.0.gemspec", :name=>"polyglot"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/term-ansicolor-1.0.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/term-ansicolor-1.0.5.gemspec", :name=>"term-ansicolor"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/treetop-1.4.4/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/treetop-1.4.4.gemspec", :name=>"treetop"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/cucumber-0.6.3/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/cucumber-0.6.3.gemspec", :name=>"cucumber"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/cucumber-rails-0.2.4/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/cucumber-rails-0.2.4.gemspec", :name=>"cucumber-rails"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/daemons-1.0.10/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/daemons-1.0.10.gemspec", :name=>"daemons"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/database_cleaner-0.4.3/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/database_cleaner-0.4.3.gemspec", :name=>"database_cleaner"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/delayed_job-1.8.4/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/delayed_job-1.8.4.gemspec", :name=>"delayed_job"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/email_spec-0.4.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/email_spec-0.4.0.gemspec", :name=>"email_spec"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/factory_girl-1.2.3/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/factory_girl-1.2.3.gemspec", :name=>"factory_girl"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/fakeweb-1.2.8/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/fakeweb-1.2.8.gemspec", :name=>"fakeweb"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/fastthread-1.0.7/lib", "/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/fastthread-1.0.7/ext"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/fastthread-1.0.7.gemspec", :name=>"fastthread"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/formtastic-0.9.7/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/formtastic-0.9.7.gemspec", :name=>"formtastic"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/gem_plugin-0.2.3/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/gem_plugin-0.2.3.gemspec", :name=>"gem_plugin"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/hashie-0.1.8/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/hashie-0.1.8.gemspec", :name=>"hashie"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/httparty-0.4.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/httparty-0.4.5.gemspec", :name=>"httparty"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/i18n-0.3.6/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/i18n-0.3.6.gemspec", :name=>"i18n"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/json-1.2.0/ext/json/ext", "/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/json-1.2.0/ext", "/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/json-1.2.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/json-1.2.0.gemspec", :name=>"json"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/launchy-0.3.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/launchy-0.3.5.gemspec", :name=>"launchy"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/memcache-client-1.8.1/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/memcache-client-1.8.1.gemspec", :name=>"memcache-client"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/mongrel-1.1.5/lib", "/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/mongrel-1.1.5/ext"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/mongrel-1.1.5.gemspec", :name=>"mongrel"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/mysql-2.8.1/lib", "/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/mysql-2.8.1/ext"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/mysql-2.8.1.gemspec", :name=>"mysql"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/ruby-hmac-0.4.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/ruby-hmac-0.4.0.gemspec", :name=>"ruby-hmac"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/oauth-0.3.6/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/oauth-0.3.6.gemspec", :name=>"oauth"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/pickle-0.2.1/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/pickle-0.2.1.gemspec", :name=>"pickle"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/rails-2.3.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/rails-2.3.5.gemspec", :name=>"rails"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/rspec-1.3.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/rspec-1.3.0.gemspec", :name=>"rspec"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/remarkable-3.1.13/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/remarkable-3.1.13.gemspec", :name=>"remarkable"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/remarkable_activerecord-3.1.13/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/remarkable_activerecord-3.1.13.gemspec", :name=>"remarkable_activerecord"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/rspec-rails-1.3.2/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/rspec-rails-1.3.2.gemspec", :name=>"rspec-rails"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/remarkable_rails-3.1.13/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/remarkable_rails-3.1.13.gemspec", :name=>"remarkable_rails"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/searchlogic-2.4.10/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/searchlogic-2.4.10.gemspec", :name=>"searchlogic"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/settingslogic-2.0.5/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/settingslogic-2.0.5.gemspec", :name=>"settingslogic"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/text-hyphen-1.0.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/text-hyphen-1.0.0.gemspec", :name=>"text-hyphen"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/text-format-1.0.0/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/text-format-1.0.0.gemspec", :name=>"text-format"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/tmail-1.2.7.1/lib", "/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/tmail-1.2.7.1/ext/tmailscanner"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/tmail-1.2.7.1.gemspec", :name=>"tmail"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/twitter-0.8.3/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/twitter-0.8.3.gemspec", :name=>"twitter"},
        {:load_paths=>["/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/gems/tzinfo-0.3.17/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/projects/rails/brandizzle/brandizzle/vendor/bundler_gems/specifications/tzinfo-0.3.17.gemspec", :name=>"tzinfo"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/whenever-0.4.1/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/whenever-0.4.1.gemspec", :name=>"whenever"},
        {:load_paths=>["/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/gems/will_paginate-2.3.12/lib"], :loaded_from=>"/Volumes/Storage/cristiduma/.rvm/gems/ruby-1.8.7-p249/specifications/will_paginate-2.3.12.gemspec", :name=>"will_paginate"},
      ].map do |hash|
    if hash[:virtual_spec]
      spec = eval(hash[:virtual_spec], binding, "<virtual spec for '#{hash[:name]}'>")
    else
      dir = File.dirname(hash[:loaded_from])
      spec = Dir.chdir(dir){ eval(File.read(hash[:loaded_from]), binding, hash[:loaded_from]) }
    end
    spec.loaded_from = hash[:loaded_from]
    spec.require_paths = hash[:load_paths]
    spec
  end

  extend SharedHelpers

  def self.configure_gem_path_and_home(specs)
    # Fix paths, so that Gem.source_index and such will work
    paths = specs.map{|s| s.installation_path }
    paths.flatten!; paths.compact!; paths.uniq!; paths.reject!{|p| p.empty? }
    ENV['GEM_PATH'] = paths.join(File::PATH_SEPARATOR)
    ENV['GEM_HOME'] = paths.first
    Gem.clear_paths
  end

  def self.match_fingerprint
    print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))
    unless print == FINGERPRINT
      abort 'Gemfile changed since you last locked. Please `bundle lock` to relock.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    clean_load_path
    cripple_rubygems(SPECS)
    configure_gem_path_and_home(SPECS)
    SPECS.each do |spec|
      Gem.loaded_specs[spec.name] = spec
      $LOAD_PATH.unshift(*spec.require_paths)
    end
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group.to_sym] || []).each do |file, explicit|
        if explicit
          Kernel.require file
        else
          begin
            Kernel.require file
          rescue LoadError
          end
        end
      end
    end
  end

  # Setup bundle when it's required.
  setup
end
