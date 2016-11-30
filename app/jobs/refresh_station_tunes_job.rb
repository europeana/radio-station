# frozen_string_literal: true
##
# Updates the set of tunes associated with a station by:
# - creating a temporary playlist for the station
# - querying the Search API for all records on the station and adding the
#   tunes as tracks to the playlist
# - once complete, setting the station's tunes to be the set of tunes on the
#   playlist, then randomising the playlist and making it live
class RefreshStationTunesJob < ApplicationJob
  queue_as :api_search

  ##
  # @param station_id [Fixnum] ID of `Station` to refresh tracks for
  # @param cursor [String] API search cursor
  # @param playlist_id [Fixnum] ID of `Playlist` to write to
  def perform(station_id, cursor = '*', playlist_id = nil)
    station = Station.find(station_id)
    playlist = Playlist.find_by_id(playlist_id) || Playlist.create!(station_id: station_id)

    api_response(station, cursor).tap do |response|
      unless response['nextCursor'].nil?
        self.class.perform_later(station_id, response['nextCursor'], playlist.id)
      end

      (response['items'] || []).each do |track|
        PlayTunesFromRecordsJob.perform_later(track['id'], playlist.id)
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
