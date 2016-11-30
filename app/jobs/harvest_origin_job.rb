# frozen_string_literal: true
class HarvestOriginJob < ApplicationJob
  queue_as :api_record

  def perform(europeana_record_id)
    # Create or update `Origin` record
    origin = Origin.find_or_create_by_europeana_record_id(europeana_record_id)
    origin.metadata = fetch(europeana_record_id)
    origin.save!
  end

  def fetch(europeana_record_id)
    Europeana::API.record.fetch(id: europeana_record_id)['object']
  end
end
