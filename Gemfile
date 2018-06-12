# frozen_string_literal: true
source 'https://rubygems.org'

gem 'rails', '~> 5.2.0'

gem 'clockwork'
gem 'europeana-api'
gem 'jbuilder'
gem 'mail'
gem 'pg'
gem 'rack-cors'
gem 'sidekiq'
gem 'stringex'

group :production do
  gem 'europeana-logging'
end

group :production, :development do
  gem 'newrelic_rpm'
  gem 'puma'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem 'foreman'
  gem 'rubocop', '0.54', require: false
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'simplecov', require: false
  gem 'shoulda-context'
  gem 'shoulda-matchers'
  gem 'webmock'
end
