# frozen_string_literal: true
class AssociateStationsWithTunes < ActiveRecord::Migration[5.0]
  def change
    create_table :stations_tunes, id: false do |t|
      t.belongs_to :station, index: true
      t.belongs_to :tune, index: true
    end

    reversible do |dir|
      dir.up do
        execute('INSERT INTO stations_tunes (station_id, tune_id) (SELECT DISTINCT stations.id station_id, tunes.id tune_id FROM stations INNER JOIN playlists ON stations.id=playlists.station_id INNER JOIN tracks ON tracks.playlist_id=playlists.id INNER JOIN tunes ON tracks.tune_id=tunes.id)')
      end
    end
  end
end
