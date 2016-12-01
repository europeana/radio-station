# frozen_string_literal: true
##
# Updates the set of tunes associated with a station by:
# - creating a temporary playlist for the station
# - querying the Search API for all records on the station and adding the
#   tunes as tracks to the playlist
# - once complete, setting the station's tunes to be the set of tunes on the
#   playlist, then randomising the playlist and making it live
class RefreshStationTunesJob < ApplicationJob
  queue_as :refresh_station_tunes

  before_enqueue do |job|
    playlist_id = job.arguments[2]
    unless playlist_id.nil?
      playlist = Playlist.find(playlist_id)
      playlist.increment!(:jobs)
    end
  end

  after_perform do |job|
    playlist_id = job.arguments[2]
    unless playlist_id.nil?
      playlist = Playlist.find(playlist_id)
      playlist.decrement!(:jobs)
      MakePlaylistLiveJob.perform_later(playlist_id) if playlist.jobs.zero?
    end
  end

  ##
  # @param station_id [Fixnum] ID of `Station` to refresh tracks for
  # @param cursor [String] API search cursor
  # @param playlist_id [Fixnum] ID of `Playlist` to write to
  def perform(station_id, cursor = '*', playlist_id = nil)
    station = Station.find(station_id)

    if playlist_id.nil?
      playlist = Playlist.create!(station_id: station_id)
      self.class.perform_later(station_id, cursor, playlist.id)
      return
    end

    playlist = Playlist.find_by_id(playlist_id)

    api_response(station, cursor).tap do |response|
      unless response['nextCursor'].nil?
        self.class.perform_later(station_id, response['nextCursor'], playlist.id)
      end

      (response['items'] || []).each do |item|
        origin = Origin.find_by_europeana_record_id(item['id'])
        is_last_tune = 

        if origin.present?
          AddOriginTunesToPlaylistJob.perform_later(origin.id, playlist.id)
        else
          HarvestOriginJob.perform_later(item['id'], playlist.id)
        end
      end
    end
  end

  protected

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
