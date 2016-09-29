# frozen_string_literal: true
json.plays @recent do |play|
  json.station play.track.station.name
  json.audio play.track.uri
  json.title play.track.title
  json.europeanaId play.track.europeana_record_id
  json.provider play.track.provider
  json.playedAt play.created_at
end
