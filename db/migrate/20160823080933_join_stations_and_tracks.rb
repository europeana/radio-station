# frozen_string_literal: true
class JoinStationsAndTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :stations_tracks, id: false do |t|
      t.belongs_to :station, index: true
      t.belongs_to :track, index: true
    end
  end
end
