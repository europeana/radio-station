json.station do
  json.name @station.name
  json.link station_url(@station)
  json.playlist @station.playlist.tracks do |track|
    json.link track.uri
  end
end
