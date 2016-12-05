# frozen_string_literal: true
class ShuffleStationPlaylistJob < ApplicationJob
  queue_as :playlist_generation

  def perform(station_id)
    station = Station.find_by_id(station_id)
    return if station.nil? || station.tunes.count.zero?
    if playlist = Playlist.find_by(station_id: station_id, live: true)
      playlist.randomise_tracks
    else
      Playlist.transaction do
        playlist = Playlist.create(station_id: station_id)
        playlist.generate_tracks
        playlist.live!
      end
    end
  end
end
