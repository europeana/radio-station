# frozen_string_literal: true
require 'sidekiq/api'

class AddOriginTunesToPlaylistJob < ApplicationJob
  queue_as :add_origin_tunes_to_playlist

  before_enqueue do |job|
    playlist_id = job.arguments[1]
    playlist = Playlist.find(playlist_id)
    playlist.increment!(:jobs)
  end

  after_perform do |job|
    playlist_id = job.arguments[1]
    playlist = Playlist.find(playlist_id)
    playlist.decrement!(:jobs)
    MakePlaylistLiveJob.perform_later(playlist_id) if playlist.jobs.zero?
  end

  def perform(origin_id, playlist_id)
    origin = Origin.find(origin_id)
    playlist = Playlist.find(playlist_id)

    # Create `Track` records
    origin.tunes.each do |tune|
      playlist.station.tunes << tune

      # Create `Track` record
      Track.create(playlist_id: playlist.id, tune_id: tune.id)
    end
  end
end
