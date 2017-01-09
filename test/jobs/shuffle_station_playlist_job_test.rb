# frozen_string_literal: true
require 'test_helper'

class ShuffleStationPlaylistJobTest < ActiveJob::TestCase
  def setup
    @station = stations(:classical)
  end

  test 'it reuses the existing live playlist for the station' do
    playlist_ids_before = @station.playlist_ids
    ShuffleStationPlaylistJob.perform_now(@station.id)
    playlist_ids_after = @station.reload.playlist_ids
    assert_equal(playlist_ids_before, playlist_ids_after)
  end

  # pending: need a big playlist of many tracks to test this
#  test 'it randomises station tunes as tracks on the playlist'

  test 'it creates a new live playlist if there is not one' do
    @station.playlist.destroy
    assert_not(@station.playlists.last.live)
    playlist_count_was = @station.playlists.count
    ShuffleStationPlaylistJob.perform_now(@station.id)
    assert(@station.playlists.last.live)
    assert_not_equal(playlist_count_was, @station.playlists.count)
  end

  test 'it destroys other live station playlists' do
    3.times do
      ShuffleStationPlaylistJob.perform_now(@station.id)
    end
    assert_equal(1, @station.playlists.where(live: true).count)
  end
end
