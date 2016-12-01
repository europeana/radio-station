# frozen_string_literal: true
class HarvestOriginJob < ApplicationJob
  queue_as :api_record

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

  def perform(europeana_record_id, playlist_id)
    # Create or update `Origin` record
    origin = Origin.find_or_create_by(europeana_record_id: europeana_record_id)
    origin.metadata = fetch_europeana_record(europeana_record_id)
    origin.save!

    AddOriginTunesToPlaylistJob.perform_later(origin.id, playlist_id)
  end
end
