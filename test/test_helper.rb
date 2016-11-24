# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'webmock/minitest'

require 'coveralls'
require 'simplecov'

# Test coverage reports
if Coveralls.will_run?.nil?
  # Generate Simplecov report during local testing
  SimpleCov.start
else
  # Submit Coveralls report in CI env
  Coveralls.wear!('rails')
end

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end
