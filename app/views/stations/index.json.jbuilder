# frozen_string_literal: true
json.stations @stations do |station|
  json.name station.name
  json.link station_url(station, format: 'json')
  json.totalResults station.playlist_length
  json.totalPlays station.plays
end
