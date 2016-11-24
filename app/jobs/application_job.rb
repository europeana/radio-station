# frozen_string_literal: true
class ApplicationJob < ActiveJob::Base
  def api_playable_audio_qf_params
    %w(MEDIA:true SOUND_DURATION:medium SOUND_DURATION:long TYPE:SOUND)
  end
end
