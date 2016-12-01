# frozen_string_literal: true
require 'sidekiq/api'

##
# Updates the set of tunes associated with a station by:
# - creating a temporary playlist for the station
# - querying the Search API for all records on the station and adding the
#   tunes as tracks to the playlist
# - once complete, setting the station's tunes to be the set of tunes on the
#   playlist, then randomising the playlist and making it live
class RefreshStationTunesJob < ApplicationJob
  queue_as :refresh_station_tunes

  after_perform do |job|
    # Make playlist live if this is the last tune
    unless job.playlist_has_more_jobs_queued?(job.playlist_id)
      MakePlaylistLiveJob.perform_later(job.playlist_id)
    end
  end

  attr_reader :playlist_id

  ##
  # @param station_id [Fixnum] ID of `Station` to refresh tracks for
  # @param cursor [String] API search cursor
  # @param playlist_id [Fixnum] ID of `Playlist` to write to
  def perform(station_id, cursor = '*', playlist_id = nil)
    station = Station.find(station_id)
    playlist = Playlist.find_by_id(playlist_id) || Playlist.create!(station_id: station_id)
    @playlist_id = playlist.id

    api_response(station, cursor).tap do |response|
      unless response['nextCursor'].nil?
        self.class.perform_later(station_id, response['nextCursor'], playlist.id)
      end

      (response['items'] || []).each do |item|
        origin = Origin.find_by_europeana_record_id(item['id'])

        unless origin.present?
          HarvestOriginJob.perform_later(item['id'])
          next
        end

        # Create `Track` records
        origin.tunes.each do |tune|
          # Create `Track` record
          Track.create(playlist_id: playlist.id, tune_id: tune.id)
        end
      end
    end
  end

  protected

  def playlist_has_more_jobs_queued?(playlist_id)
    Sidekiq::Queue.new(:refresh_station_tunes).any? { |job| job.args.first['arguments'][2] == playlist_id }
  end

  def api_response(station, cursor = '*')
    Europeana::API.record.search(api_search_params(station, cursor))
  end

  def api_search_params(station, cursor = '*')
    {
      query: station.api_query,
      rows: 100,
      profile: 'minimal',
      qf: api_playable_audio_qf_params,
      cursor: cursor
    }
  end
end
