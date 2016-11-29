# frozen_string_literal: true
json.station do
  json.name @station.name
  json.link send(:"#{@station.theme_type}_station_url", slug: @station.slug, format: 'json')
  json.totalResults @total_tracks
  json.playlist @tracks do |track|
    if track.is_a?(Track)
      json.audio play_tune_url(id: track.tune.uuid, station_id: track.station.id)
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
    end
  end
end
