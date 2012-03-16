# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
#require File.expand_path("../../config/environment", __FILE__)
if RUBY_VERSION =~ /\A1.9.*/
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
    coverage_dir '/tmp/cov'
  end
end

require 'app'
require 'rspec/rails'
require 'assumption'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require File.expand_path(f)}

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
  end
  config.before do
  end

  config.after do
  end
end

