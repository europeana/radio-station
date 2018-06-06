# frozen_string_literal: true

unless ENV.key?('REDIS_URL') && ENV['REDIS_URL'].present?
  # Prefer the redis URI from the REDIS_URI env var if specified.
  if ENV.key?('REDIS_URI') && ENV['REDIS_URI'].present?
    uri = ENV['REDIS_URI']
  elsif ENV.key?('VCAP_SERVICES')
    services = JSON.parse(ENV['VCAP_SERVICES'])
    redis_config = services['compose-for-redis']
    uri = redis_config.first['credentials']['uri'] unless redis_config.nil?
  end
  fail 'No Redis service found in environment.' unless defined?(uri) && uri.present?
  ENV['REDIS_URL'] = uri
end
