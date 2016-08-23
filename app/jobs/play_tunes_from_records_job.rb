# frozen_string_literal: true
class PlayTunesFromRecordsJob < ApplicationJob
  queue_as :default

  ##
  # @param europeana_id [String] Europeana record ID of `Origin` to add to playlist
  # @param playlist_id [Fixnum] ID of `Playlist` to write track to
  def perform(europeana_record_id, playlist_id)
    # Get record from API
    record = fetch(europeana_record_id)

    # Extract pertinent web resources from API response
    # - finish here if there are none
    record_tunes = extract_tunes(record)
    return if record_tunes.blank?

    # Create or update `Origin` record
    origin = Origin.find_or_create_by(europeana_record_id: europeana_record_id)
    origin.metadata = record
    origin.save!

    # Create `Tune` and `Track` records
    record_tunes.each do |record_tune|
      tune = Tune.find_or_create_by(web_resource_uri: record_tune['about'])
      tune.origin_id ||= origin.id
      tune.save!

      # Create `Track` record
      Track.create!(playlist_id: playlist_id, tune_id: tune.id)
    end
  end

  def extract_tunes(record)
    web_resources = record['aggregations'].map { |agg| agg['webResources'] }

    web_resources.flatten.select do |wr|
      (wr['ebucoreHasMimeType'] || '').starts_with?('audio/') &&
        (wr['ebucoreDuration'] || 0).to_i >= 180
    end
  end

  def fetch(europeana_record_id)
    response = api_connection.get(url(europeana_record_id))
    response.body['object']
  end

  def url(europeana_record_id)
    uri = URI.parse("#{API_BASE_URL}/record#{europeana_record_id}.json")
    uri.query = "wskey=#{api_key}"
    Rails.logger.debug("Tune Record URL: #{uri.to_s}")
    uri.to_s
  end
end
