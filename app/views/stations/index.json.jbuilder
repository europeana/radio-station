json.stations @stations do |station|
  json.name station.name
  json.link station_url(station, format: 'json')
end
