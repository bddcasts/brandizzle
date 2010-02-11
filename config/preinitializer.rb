undef gem if defined?(gem)
def gem(*)
  # Silently ignore calls to gem
end

begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError => e
  puts e
  # Fallback on doing the resolve at runtime.
  require "rubygems"
  require "bundler"
  Bundler.setup
end
