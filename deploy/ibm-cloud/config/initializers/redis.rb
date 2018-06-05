# frozen_string_literal: true

unless ENV['REDIS_URL']
  if ENV.key?('VCAP_SERVICES')
    services = JSON.parse(ENV['VCAP_SERVICES'])
    redis_config = services['compose-for-redis'].first
  end

  fail 'No Redis service found in environment.' if redis_config.nil?

  ENV['REDIS_URL'] = redis_config['credentials']['uri']
end
