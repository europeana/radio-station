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

    playlist.live!
  rescue ActiveRecord::RecordNotFound
    # Playlist has gone away, so we can't make it live, but that's OK
  end
end
