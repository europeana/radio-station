# frozen_string_literal: true
class MakePlaylistLiveJob < ApplicationJob
  queue_as :playlist_live

  def perform(playlist_id)
    playlist = Playlist.find(playlist_id)

    # Empty playlists are not useful. Just delete them.
    if playlist.tracks.count.zero?
      playlist.destroy
      return
    end

    playlist.live = true
    playlist.save!

    other_station_playlists = Playlist.where(station_id: playlist.station_id).where.not(id: playlist_id)
    other_station_playlists.update_all(live: false)
  rescue ActiveRecord::RecordNotFound
    # Playlist has gone away, so we can't make it live, but that's OK
  end
end
