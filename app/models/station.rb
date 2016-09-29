# frozen_string_literal: true
##
# A station is one channel on the radio, with its own playlist
class Station < ApplicationRecord
  has_many :playlists, dependent: :destroy
  has_one :playlist, -> { where(live: true).order('created_at DESC') }

  validates :name, :api_query, :slug, presence: true
  validates :name, :slug, uniqueness: true

  def to_param
    slug
  end

  def playlist_length
    @playlist_length ||= (playlist.present? ? playlist.tracks.count : 0)
  end

  def plays
    Play.joins(:station).where('station_id = ?', self).count
  end
end
