# frozen_string_literal: true
Europeana::API.key = Rails.application.secrets.europeana_api_key

Europeana::API.configure do |config|
  config.parse_json_to = OpenStruct
end
