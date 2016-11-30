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
  def perform(europeana_record_id, playlist_id)
    origin = Origin.find_by_europeana_record_id(europeana_record_id)

    unless origin.present?
      HarvestOriginJob.perform_later(europeana_record_id)
      return
    end

    # Create `Track` records
    origin.tunes.each do |tune|
      # Create `Track` record
      Track.create(playlist_id: playlist_id, tune_id: tune.id)
    end
  end

  def playlist_has_more_jobs_queued?(playlist_id)
    Sidekiq::Queue.new(:api_record).any? { |job| job.args.first['arguments'][1] == playlist_id } ||
      Sidekiq::Queue.new(:api_search).any? { |job| job.args.first['arguments'][2] == playlist_id }
  end
end
