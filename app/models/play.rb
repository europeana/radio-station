# frozen_string_literal: true
class Play < ApplicationRecord
  belongs_to :track
  has_one :station, through: :track

  validates :track_id, presence: true
end
