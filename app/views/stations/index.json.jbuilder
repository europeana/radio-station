# frozen_string_literal: true
json.stations @stations do |station|
  json.name station.name
  json.link send(:"#{station.theme_type}_station_url", slug: station.slug, format: 'json')
  json.totalResults station.playlist_length
  json.totalPlays station.plays
end
