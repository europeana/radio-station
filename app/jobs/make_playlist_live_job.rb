class MakePlaylistLiveJob < ApplicationJob
  queue_as :playlist_live

  def perform(playlist_id)
    playlist = Playlist.find(playlist_id)
    playlist.live = true
    playlist.save!

    other_station_playlists = Playlist.where(station_id: playlist.station_id).where.not(id: playlist_id)
    other_station_playlists.update_all(live: false)
    other_station_playlists.where('created_at < ?', playlist.created_at).destroy_all
  end
end
