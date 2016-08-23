# frozen_string_literal: true
##
# A station is one channel on the radio, with its own playlist
class Station < ApplicationRecord
  has_many :playlists, dependent: :destroy

  validates :name, :api_query, presence: true, uniqueness: true
  validates :api_query, presence: true
end
