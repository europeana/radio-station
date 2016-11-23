# frozen_string_literal: true
json.station do
  json.name @station.name
  json.link send(:"#{@station.theme_type}_station_url", slug: @station.slug, format: 'json')
  json.totalResults @station.playlist_length
  # json.totalPlays @station.plays
  json.playlist @tracks do |track|
    if track.is_a?(Track)
      json.audio play_track_url(track)
      json.title track.title
      json.creator track.creator
      json.thumbnail track.thumbnail
      json.europeanaId track.europeana_record_id
      json.copyright track.edm_rights_label
      json.mimeType track.metadata['ebucoreHasMimeType']
      json.fileByteSize track.metadata['ebucoreFileByteSize']
      json.duration track.metadata['ebucoreDuration']
      json.sampleRate track.metadata['ebucoreSampleRate']
      json.bitRate track.metadata['ebucoreBitRate']
      # json.jingle false
    else
      json.audio track['uri']
      json.jingle true
    end
  end
end
