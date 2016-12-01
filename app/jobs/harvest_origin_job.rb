# frozen_string_literal: true
class HarvestOriginJob < ApplicationJob
  queue_as :api_record

  def perform(europeana_record_id, playlist_id)
    # Create or update `Origin` record
    origin = Origin.find_or_create_by(europeana_record_id: europeana_record_id)
    origin.metadata = fetch_europeana_record(europeana_record_id)
    origin.save!

    playlist = Playlist.find_by_id(playlist_id)
    return if playlist.nil?

    playlist.station.tunes << origin.tunes

    # Create `Track` records
    origin.tunes.each do |tune|
      # Create `Track` record
      Track.create(playlist_id: playlist.id, tune_id: tune.id)
    end
  end
end
