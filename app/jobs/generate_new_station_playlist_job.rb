# frozen_string_literal: true
class GenerateNewStationPlaylistJob < ApplicationJob
  queue_as :playlist_generation

  def perform(station_id)
    station = Station.find_by_id(station_id)
    return if station.nil? || station.tunes.count.zero?
    Playlist.create(station_id: station_id).live!
  end
end
