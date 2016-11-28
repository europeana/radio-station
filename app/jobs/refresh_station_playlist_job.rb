# frozen_string_literal: true
class RefreshStationPlaylistJob < ApplicationJob
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
        PlayTunesFromRecordsJob.perform_later(track['id'], playlist.id, track_origin_id(track))
      end
    end
  end

  protected

  def api_response(station, cursor = '*')
    Europeana::API.record.search(api_search_params(station, cursor))
  end

  def track_origin_id(track)
    origin = Origin.find_by_europeana_record_id(track['id'])

    if origin.present? && track['timestamp'].present? && ((origin.updated_at.to_i * 1000) >= track['timestamp'])
      origin.id
    end
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
