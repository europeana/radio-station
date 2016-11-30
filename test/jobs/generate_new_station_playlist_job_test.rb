# frozen_string_literal: true
require 'test_helper'

class GenerateNewStationPlaylistJobTest < ActiveJob::TestCase
  def setup
    @station = stations(:classical)
  end

  test 'it creates a new playlist for the station' do
    playlist_id_before = @station.playlists.last.id
    GenerateNewStationPlaylistJob.perform_now(@station.id)
    playlist_id_after = @station.playlists.last.id
    assert_not_equal(playlist_id_before, playlist_id_after)
  end

  test 'it randomises station tunes as tracks on the playlist' do
    GenerateNewStationPlaylistJob.perform_now(@station.id)
    playlist = @station.playlists.last
    assert_equal(@station.tunes.count, playlist.tracks.size)
  end

  test 'it makes the new playlist live' do
    GenerateNewStationPlaylistJob.perform_now(@station.id)
    playlist = @station.playlists.last
    assert(playlist.live)
  end

  test 'it destroys other station playlists' do
    3.times do
      GenerateNewStationPlaylistJob.perform_now(@station.id)
    end
    assert_equal(1, @station.playlists.count)
  end
end
