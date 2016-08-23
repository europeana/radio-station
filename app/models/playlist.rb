# frozen_string_literal: true
class Playlist < ApplicationRecord
  belongs_to :station
  has_and_belongs_to_many :tracks
end
