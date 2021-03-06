# frozen_string_literal: true
require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  should belong_to(:station)
  should have_many(:tracks).dependent(:delete_all)
  should validate_presence_of(:station_id)

  test 'it should generated randomised tracks' do
    playlist = Playlist.new(station: stations(:classical))
    assert_equal(0, playlist.tracks.length)
    assert(playlist.save)
    playlist.generate_tracks
    assert_equal(playlist.station.tunes.length, playlist.reload.tracks.length)
    assert_equal(playlist.station.tunes.length, Playlist.find(playlist.id).tracks.length)
    playlist.tracks.each do |track|
      assert_not(track.order.nil?)
    end
  end

  test 'it can be made live' do
    station = stations(:classical)
    playlist = Playlist.create(station: station)
    playlist.generate_tracks
    playlist.live!
    assert(playlist.live)
    assert(Playlist.find(playlist.id).live)
  end

  test 'it can not be made live if station has no tunes' do
    station = Station.create(theme_type: :genre, name: 'Black Metal', api_query: 'what:"black metal"')
    assert(station.valid?)
    playlist = Playlist.create(station: station)
    assert(playlist.valid?)
    assert_raises(StandardError) do
      playlist.live!
    end
  end

  test "destroys station's other live playlists once live" do
    station = stations(:classical)
    3.times do
      playlist = Playlist.create(station: station)
      playlist.generate_tracks
      playlist.live!
    end
    assert_equal(1, station.playlists.where(live: true).count)
  end

  test "it leaves station's non-live playlists" do
    station = stations(:classical)
    playlist = Playlist.create(station: station)
    playlist.generate_tracks
    playlist.live!
    assert(station.playlists.include?(playlists(:classical_other)))
  end

  test 'it leaves playlists for other stations once live' do
    folk_station = stations(:folk)
    folk_playlist = Playlist.create(station: folk_station)
    folk_playlist.generate_tracks
    assert(folk_playlist.valid?)
    folk_playlist.live!

    classical_station = stations(:classical)
    classical_playlist = Playlist.create(station: classical_station)
    classical_playlist.generate_tracks
    assert(classical_playlist.valid?)
    classical_playlist.live!

    assert_not(Playlist.find_by_id(folk_playlist.id).nil?)
  end
end
