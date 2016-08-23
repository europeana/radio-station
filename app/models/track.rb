# frozen_string_literal: true
##
# A track is a tune appearing at a particular place on a playlist
class Track < ApplicationRecord
  belongs_to :playlist
  belongs_to :tune

  validates :playlist_id, :tune_id, :order, presence: true
end
