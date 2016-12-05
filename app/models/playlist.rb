# frozen_string_literal: true
##
# A playlist is a set of tunes to be played on a station
class Playlist < ApplicationRecord
  belongs_to :station
  has_many :tracks, -> { order('order': :asc) }, dependent: :destroy
  has_many :tunes, through: :tracks

  validates :station_id, presence: true

  def generate_tracks
    transaction do
      station.tune_ids.shuffle.each_with_index do |tune_id, index|
        Track.create!(tune_id: tune_id, playlist_id: id, order: index + 1)
      end
    end
  end

  def randomise_tracks
    Track.transaction do
      track_ids.shuffle.each_with_index do |track_id, index|
        Track.where(id: track_id).update_all(order: index + 1)
      end
    end
  end

  def live!
    fail 'Playlist has no tracks' unless tracks.present?
    self.transaction do
      update_attributes(live: true)
      station.playlists.where(live: true).where.not(id: self.id).find_each(&:destroy)
    end
  end
end
