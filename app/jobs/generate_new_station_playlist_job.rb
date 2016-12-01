# frozen_string_literal: true
class GenerateNewStationPlaylistJob < ApplicationJob
  queue_as :playlist_generation

  def perform(station_id)
    Playlist.create(station_id: station_id).live!
  end
end
