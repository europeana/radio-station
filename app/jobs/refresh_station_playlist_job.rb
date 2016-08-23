# frozen_string_literal: true
# @todo Separate jobs for refreshing playlists and refreshing existing track metadata
class RefreshStationPlaylistJob < ApplicationJob
  queue_as :default

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

    response.body['items'].each do |track|
      PlayTunesFromRecordsJob.perform_later(track['id'], playlist.id)
    end
  end

  protected

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
