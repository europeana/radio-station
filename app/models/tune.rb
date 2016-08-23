##
# A tune is one audio recording that can be played on the radio
class Tune < ApplicationRecord
  belongs_to :origin

  validates :origin_id, :web_resource_uri, presence: true
  validates :web_resource_uri, uniqueness: true

  def metadata
    origin.web_resources.find { |wr| wr['about'] == web_resource_uri }
  end
end
