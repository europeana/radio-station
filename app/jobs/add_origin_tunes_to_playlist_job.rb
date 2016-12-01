# frozen_string_literal: true
class AddOriginTunesToPlaylistJob < ApplicationJob
  queue_as :refresh_station_tunes

  def perform(origin_id, playlist_id)
    origin = Origin.find_by_id(origin_id)
    playlist = Playlist.find_by_id(playlist_id)
    return if origin.nil? || playlist.nil?

    playlist.station.tunes << origin.tunes

    # Create `Track` records
    origin.tunes.each do |tune|
      # Create `Track` record
      Track.create(playlist_id: playlist.id, tune_id: tune.id)
    end
  end
end
