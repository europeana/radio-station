json.plays @recent do |play|
  json.station play.station
  json.audio play.web_resource_uri
  json.title play.title
  json.europeanaId play.europeana_record_id
  json.provider play.provider
  json.playedAt play.created_at
end
