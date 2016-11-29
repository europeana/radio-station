# frozen_string_literal: true
##
# A track is a tune appearing at a particular position on a playlist
class Track < ApplicationRecord
  belongs_to :playlist
  belongs_to :tune

  has_one :origin, through: :tune
  has_one :station, through: :playlist

  delegate :metadata, :thumbnail, :uri, :title, :creator, :europeana_record_id,
           :edm_rights, :edm_rights_label, :provider, to: :tune

  validates :playlist_id, :tune_id, :order, :uuid, presence: true
  validates :tune_id, uniqueness: { scope: :playlist_id }
  validates :order, uniqueness: { scope: :playlist_id }

  before_validation do |track|
    # Set a random track order, unique to this playlist
    while track.order.nil?
      track.order = rand(2_147_483_647) # PG int max
      if Track.where.not(id: track.id).where(playlist_id: track.playlist_id, order: track.order).count > 0
        track.order = nil
      end
    end

    while track.uuid.nil?
      track.uuid = SecureRandom.uuid
      if Track.where(uuid: track.uuid).count > 0
        track.uuid = nil
      end
    end
  end

  def to_param
    uuid
  end
end
