# frozen_string_literal: true
##
# A playlist is a set of tunes to be played on a station
class Playlist < ApplicationRecord
  belongs_to :station
  has_many :tracks, -> { order('order': :asc) }, dependent: :destroy

  validates :station_id, presence: true

  validate :station_has_tunes

  before_create :generate

  def generate
    self.tracks = station.tunes.map { |tune| Track.new(tune: tune, playlist: self) }
  end

  def live!
    self.transaction do
      update_attributes(live: true)
      station.playlists.where(live: true).where.not(id: self.id).find_each(&:destroy)
    end
  end

  def station_has_tunes
    errors.add(:station, 'has no tunes') unless station.blank? || station.tunes.count.nonzero?
  end
end
