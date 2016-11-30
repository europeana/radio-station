# frozen_string_literal: true
require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  should belong_to(:station)
  should have_many(:tracks).dependent(:destroy)
  should validate_presence_of(:station_id)

  test 'it should generated randomised tracks' do
    playlist = Playlist.new(station: stations(:classical))
    assert_equal(0, playlist.tracks.length)
    assert(playlist.save)
    assert_equal(playlist.station.tunes.length, playlist.tracks.length)
    assert_equal(playlist.station.tunes.length, Playlist.find(playlist.id).tracks.length)
    playlist.tracks.each do |track|
      assert_not(track.order.nil?)
    end
  end

  test 'it is invalid if station has no tunes' do
    station = Station.create(theme_type: :genre, name: 'Black Metal', api_query: 'what:"black metal"')
    assert(station.valid?)
    playlist = Playlist.create(station: station)
    assert_not(playlist.valid?)
    assert(playlist.errors[:station].any?)
  end

  test 'it can be made live' do
    station = stations(:classical)
    playlist = Playlist.create(station: station)
    playlist.live!
    assert(playlist.live)
    assert(Playlist.find(playlist.id).live)
  end

  test "destroys station's other playlists once live" do
    station = stations(:classical)
    3.times do
      playlist = Playlist.create(station: station)
      playlist.live!
    end
    assert_equal(1, station.playlists.count)
  end

  test 'it leaves playlists for other stations once live' do
    folk_station = stations(:folk)
    folk_playlist = Playlist.create(station: folk_station)
    assert(folk_playlist.valid?)
    folk_playlist.live!

    classical_station = stations(:classical)
    classical_playlist = Playlist.create(station: classical_station)
    assert(classical_playlist.valid?)
    classical_playlist.live!

    assert_not(Playlist.find_by_id(folk_playlist.id).nil?)
  end
end
