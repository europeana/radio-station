# frozen_string_literal: true
##
# A station is one channel on the radio, with its own playlist
class Station < ApplicationRecord
  has_many :playlists, dependent: :destroy

  validates :name, :api_query, :slug, presence: true
  validates :name, :slug, uniqueness: true

  def to_param
    slug
  end

  def playlist
    playlists.where(live: true).order('created_at DESC').first
  end

  def playlist_length
    (playlist.present? && playlist.tracks.present?) ? playlist.tracks.count : 0
  end
end
