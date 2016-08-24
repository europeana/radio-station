class MakePlaylistLiveJob < ApplicationJob
  queue_as :playlist_live

  def perform(playlist_id)
    playlist = Playlist.find(playlist_id)
    playlist.live = true
    playlist.save!

    other_station_playlists = Playlist.where('station_id = ? AND id <> ?', playlist.station_id, playlist_id)
    other_station_playlists.update_all(live: false)
    other_station_playlists.destroy_all
  end
end
