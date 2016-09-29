# frozen_string_literal: true
class ApplicationJob < ActiveJob::Base
  def api_url
    Rails.application.config.x.europeana_api_url
  end

  def api_key
    Rails.application.secrets.europeana_api_key
  end

  def api_connection
    @connection ||= Faraday.new do |conn|
      conn.adapter Faraday.default_adapter
      conn.request :retry, max: 5, interval: 3,
                           exceptions: [Errno::ECONNREFUSED, Errno::ETIMEDOUT, 'Timeout::Error',
                                        Faraday::Error::TimeoutError, EOFError]
      conn.response :json, content_type: /\bjson$/
    end
  end
end
