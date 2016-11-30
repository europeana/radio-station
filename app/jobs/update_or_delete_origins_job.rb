class UpdateOrDeleteOriginsJob < ApplicationJob
  queue_as :api_record

  def perform(origin_id = nil)
    if origin_id.nil?
      Origin.find_each do |origin|
        self.class.perform_later(origin.id)
      end
      return
    end

    origin = Origin.find_by_id(origin_id)
    return if origin.nil?

    record = fetch_europeana_record(origin.europeana_record_id)
    origin.update_attributes(metadata: record)
  rescue Europeana::API::Errors::ResourceNotFoundError
    origin.destroy
  end
end
