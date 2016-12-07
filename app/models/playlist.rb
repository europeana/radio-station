# frozen_string_literal: true
##
# A playlist is a set of tunes to be played on a station
class Playlist < ApplicationRecord
  belongs_to :station
  has_many :tracks, -> { order('order': :asc) }, dependent: :delete_all
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
    fail 'Playlist has jobs pending' unless jobs.zero?
    transaction do
      update_attributes(live: true)
      update_station_tune_ids
      station.playlists.where(live: true).where.not(id: self.id).find_each(&:destroy)
    end
  end

  private

  # Using #tune_ids= consumes too much memory with very large playlists
  def update_station_tune_ids
    transaction do
      self.class.connection.execute("DELETE FROM stations_tunes WHERE station_id=#{station_id}")
      tune_ids.each_slice(1000) do |batch|
        ids_sql = batch.map(&:to_s).join(',')
        sql = "INSERT INTO stations_tunes(station_id, tune_id) SELECT #{station_id} station_id, tune_id FROM unnest(ARRAY[#{ids_sql}]) tune_id"
        self.class.connection.execute(sql)
      end
    end
  end
end
