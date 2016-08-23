# frozen_string_literal: true
##
# A track is a tune appearing at a particular place on a playlist
class Track < ApplicationRecord
  belongs_to :playlist
  belongs_to :tune

  validates :playlist_id, :tune_id, :order, presence: true
  validates :order, uniqueness: { scope: :playlist_id }

  before_validation do |track|
    # Set a random track order, unique to this playlist
    while track.order.blank? or (Track.where(playlist_id: track.playlist_id, order: track.order).count > 0)
      track.order = rand(2147483647) unless track.order.present? # PG int max
    end
  end

  def uri
    tune.web_resource_uri
  end
end
