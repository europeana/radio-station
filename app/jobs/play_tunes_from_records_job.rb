# frozen_string_literal: true
require 'sidekiq/api'

# @todo Name this something clearer, but less fun :`(
class PlayTunesFromRecordsJob < ApplicationJob
  queue_as :api_record

  after_perform do |job|
    playlist_id = job.arguments[1]

    # Make playlist live if this is the last tune
    unless job.playlist_has_more_jobs_queued?(playlist_id)
      MakePlaylistLiveJob.perform_later(playlist_id)
    end
  end

  ##
  # @param europeana_id [String] Europeana record ID of `Origin` to add to playlist
  # @param playlist_id [Fixnum] ID of `Playlist` to write track to
  def perform(europeana_record_id, playlist_id, origin_id = nil)
    if origin_id.present?
      # Get record from `Origin`
      origin = Origin.find(origin_id)
      record = origin.metadata
    else
      # Get record from API
      record = fetch(europeana_record_id)

      # Create or update `Origin` record
      origin = Origin.find_or_create_by(europeana_record_id: europeana_record_id)
      origin.metadata = record
    end

    # Extract pertinent web resources from API response & return if there are none
    record_tunes = extract_tunes(record)
    return if record_tunes.blank?

    # Save `Origin` if it's new, and we know there are pertinent web resources
    origin.save! if origin.new_record?

    # Create `Tune` and `Track` records
    record_tunes.each do |record_tune|
      tune = Tune.find_or_create_by(web_resource_uri: record_tune['about'])
      tune.origin_id ||= origin.id
      tune.save!

      # Create `Track` record
      Track.create(playlist_id: playlist_id, tune_id: tune.id)
    end
  end

  def playlist_has_more_jobs_queued?(playlist_id)
    Sidekiq::Queue.new(:api_record).any? { |job| job.args.first['arguments'][1] == playlist_id } ||
      Sidekiq::Queue.new(:api_search).any? { |job| job.args.first['arguments'][2] == playlist_id }
  end

  def extract_tunes(record)
    web_resources = record['aggregations'].map { |agg| agg['webResources'] }

    web_resources.flatten.select do |wr|
      (wr['ebucoreHasMimeType'] || '').starts_with?('audio/') &&
        (wr['ebucoreDuration'] || 0).to_i >= 180_000
    end
  end

  def fetch(europeana_record_id)
    response = api_connection.get(url(europeana_record_id))
    response.body['object']
  end

  def url(europeana_record_id)
    uri = URI.parse("#{api_url}/record#{europeana_record_id}.json")
    uri.query = "wskey=#{api_key}"
    Rails.logger.debug("Tune Record URL: #{uri}")
    uri.to_s
  end
end
