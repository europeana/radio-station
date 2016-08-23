# frozen_string_literal: true
class JoinPlaylistsAndTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists_tracks, id: false do |t|
      t.belongs_to :playlist, index: true
      t.belongs_to :track, index: true
    end
  end
end
