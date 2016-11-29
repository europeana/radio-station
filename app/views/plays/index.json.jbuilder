# frozen_string_literal: true
json.plays @recent do |play|
  json.station play.station.nil? ? nil : play.station.name
  json.audio play.tune.uri
  json.title play.tune.title
  json.europeanaId play.tune.europeana_record_id
  json.provider play.tune.provider
  json.playedAt play.created_at
end
