# frozen_string_literal: true
require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
# require "action_mailer/railtie"
require 'action_view/railtie'
# require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Europeana
  module RadioStation
    class Application < Rails::Application
      # Settings in config/environments/* take precedence over those specified here.
      # Application configuration should go into files in config/initializers
      # -- all .rb files in that directory are automatically loaded.

      # Only loads a smaller set of middleware suitable for API only apps.
      # Middleware like session, flash, cookies can be added back manually.
      # Skip views, helpers and assets when generating a new resource.
      config.api_only = true

      config.active_job.queue_adapter = :sidekiq

      # Amsterdam timezone
      config.time_zone = 'Amsterdam'

      # Unrestricted CORS
      config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins '*'
          resource '*', headers: :any, methods: [:get, :head, :options]
        end
      end

      # Set Europeana API URL
      Rails.application.config.x.europeana_api_url = ENV['EUROPEANA_API_URL'] || 'https://www.europeana.eu/api/v2'
    end
  end
end
