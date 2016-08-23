# frozen_string_literal: true
##
# A playlist is a set of tunes to be played on a station
class Playlist < ApplicationRecord
  belongs_to :station
  has_many :tracks, -> { order('order': :asc) }, dependent: :destroy

  validates :station_id, presence: true
end
