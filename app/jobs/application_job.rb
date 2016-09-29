# frozen_string_literal: true
class ApplicationJob < ActiveJob::Base
  API_BASE_URL = 'https://www.europeana.eu/api/v2'

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
