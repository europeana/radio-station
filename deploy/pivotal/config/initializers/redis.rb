# frozen_string_literal: true
if ENV.key?('VCAP_SERVICES')
  services = JSON.parse(ENV['VCAP_SERVICES'])
  redis_config = services['rediscloud'].first
end

fail 'No Redis service found in environment.' if redis_config.nil?

redis_cred = redis_config['credentials']
ENV['REDIS_URL'] = "redis://:#{redis_cred['password']}@#{redis_cred['hostname']}:#{redis_cred['port']}/0/jobs"
