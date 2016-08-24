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

    response = api_connection.get(url(station, cursor))

    unless response.body['nextCursor'].nil?
      self.class.perform_later(station_id, response.body['nextCursor'], playlist.id)
    end

    response.body.fetch('items', []).each do |track|
      PlayTunesFromRecordsJob.perform_later(track['id'], playlist.id, track_origin_id(track))
    end
  end

  protected

  def track_origin_id(track)
    origin = Origin.find_by_europeana_record_id(track['id'])

    if origin.present? && track['timestamp'].present? && ((origin.updated_at.to_i * 1000) >= track['timestamp'])
      origin.id
    else
      nil
    end
  end

  def url(station, cursor = '*')
    uri = URI.parse(API_BASE_URL + '/search.json')

    query = {
      query: station.api_query,
      rows: 100,
      profile: 'minimal',
      qf: [
        'MEDIA:true',
        'SOUND_DURATION:medium',
        'SOUND_DURATION:long',
        'TYPE:SOUND'
      ],
      wskey: api_key,
      cursor: cursor
    }

    uri.query = Rack::Utils.build_query(query)

    Rails.logger.debug("Station Search URL: #{uri.to_s}")
    uri.to_s
  end
end
