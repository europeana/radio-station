# frozen_string_literal: true
require 'test_helper'

class GenerateRandomStationPlaylistJobTest < ActiveJob::TestCase
  def setup
    @station = stations(:classical)
  end

  test 'it creates a non-live playlist for the station' do
    playlist_count_before = @station.playlists.count
    GenerateRandomStationPlaylistJob.perform_now(@station.id)
    playlist_count_after = @station.playlists.count
    assert_equal(playlist_count_before + 1, playlist_count_after)
    assert_equal(false, @station.playlists.last.live)
  end

  test 'it randomises station tunes as tracks on the playlist' do
  
  end
end
