# frozen_string_literal: true
##
# A station is one channel on the radio, with its own playlist
class Station < ApplicationRecord
  has_many :playlists, dependent: :destroy
  has_one :playlist, -> { where(live: true).order('created_at DESC') }
  has_many :plays, dependent: :nullify
  has_and_belongs_to_many :tunes

  validates :name, :api_query, :slug, presence: true
  validates :name, :slug, uniqueness: { scope: :theme_type }

  default_scope { order('name ASC') }

  # NB: we are not really allowing duplicates, but rather want the uniqueness
  # validation above to fail, preventing record creation.
  acts_as_url :name, url_attribute: :slug, only_when_blank: true,
                     allow_duplicates: true

  enum theme_type: [:genre, :institution]

  def playlist_length
    @playlist_length ||= (playlist.present? ? playlist.tracks.count : 0)
  end
end
