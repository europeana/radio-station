# frozen_string_literal: true
source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

gem 'clockwork', '~> 2.0'
gem 'europeana-logging', '~> 0.0.3'
gem 'faraday', '~> 0.9'
gem 'faraday_middleware', '~> 0.10'
gem 'jbuilder', '~> 2.6'
gem 'pg', '~> 0.18'
gem 'rack-cors'
gem 'sidekiq'

group :production, :development do
  gem 'newrelic_rpm', '~> 3.16'
  gem 'puma', '~> 3.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'dotenv-rails', '~> 2.1'
  gem 'foreman'
  gem 'rubocop', '0.39.0', require: false # only update when Hound does
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'coveralls', require: false
  gem 'shoulda-context', '~> 1.2'
  gem 'shoulda-matchers', '~> 3.1'
end
