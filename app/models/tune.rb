##
# A tune is one audio recording that can be played on the radio
class Tune < ApplicationRecord
  belongs_to :origin

  validates :origin_id, :web_resource_uri, presence: true
  validates :web_resource_uri, uniqueness: true

  delegate :title, :thumbnail, :europeana_record_id, to: :origin

  def uri
    web_resource_uri
  end

  def metadata
    @metadata ||= origin.web_resources.find { |wr| wr['about'] == web_resource_uri }
  end

  def creator
    Origin.creator(metadata) || origin.creator
  end
end
