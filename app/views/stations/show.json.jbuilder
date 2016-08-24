json.station do
  json.name @station.name
  json.link station_url(@station, format: 'json')
  json.totalResults @station.playlist_length
  json.playlist @tracks do |track|
    json.audio track.uri
    json.title track.title
    json.creator track.creator
    json.thumbnail track.thumbnail
    json.europeanaId track.europeana_record_id
    json.mimeType track.metadata['ebucoreHasMimeType']
    json.fileByteSize track.metadata['ebucoreFileByteSize']
    json.duration track.metadata['ebucoreDuration']
    json.sampleRate track.metadata['ebucoreSampleRate']
    json.bitRate track.metadata['ebucoreBitRate']
  end
end
