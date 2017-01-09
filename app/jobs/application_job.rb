# frozen_string_literal: true
class ApplicationJob < ActiveJob::Base
  def api_playable_audio_qf_params
    %w(TYPE:SOUND provider_aggregation_edm_isShownBy:*)
  end

  def fetch_europeana_record(id)
    Europeana::API.record.fetch(id: id)['object']
  end
end
