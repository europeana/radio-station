# frozen_string_literal: true
##
# A playlist is a set of tunes to be played on a station
class Playlist < ApplicationRecord
  belongs_to :station
  has_many :tracks, -> { order('order': :asc) }, dependent: :destroy
  has_many :tunes, through: :tracks

  validates :station_id, presence: true

  before_create :generate

  def generate
    self.tracks = station.tunes.map { |tune| Track.new(tune: tune, playlist: self) }
  end

  def live!
    fail 'Playlist has no tracks' unless tracks.present?
    self.transaction do
      update_attributes(live: true)
      station.playlists.where(live: true).where.not(id: self.id).find_each(&:destroy)
    end
  end
end
