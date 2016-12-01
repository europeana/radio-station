# frozen_string_literal: true
class HarvestOriginJob < ApplicationJob
  queue_as :api_record

  def perform(europeana_record_id, playlist_id)
    # Create or update `Origin` record
    origin = Origin.find_or_create_by(europeana_record_id: europeana_record_id)
    origin.metadata = fetch_europeana_record(europeana_record_id)
    origin.save!

    AddOriginTunesToPlaylistJob.perform_later(origin.id, playlist.id)
  end
end
