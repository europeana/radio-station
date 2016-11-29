# frozen_string_literal: true
class ChangePlayAssociations < ActiveRecord::Migration[5.0]
  def up
    add_column :plays, :station_id, :integer
    add_index :plays, :station_id
    add_column :plays, :tune_id, :integer
    add_index :plays, :tune_id
    execute('UPDATE plays SET station_id=sub.station_id, tune_id=sub.tune_id FROM (SELECT plays.id play_id, tracks.tune_id tune_id, playlists.station_id station_id FROM plays INNER JOIN tracks ON plays.track_id=tracks.id INNER JOIN playlists ON tracks.playlist_id=playlists.id) sub WHERE plays.id=sub.play_id')
    remove_column :plays, :track_id
  end

  def down
    remove_column :plays, :station_id
    remove_column :plays, :tune_id
    add_column :plays, :track_id, :integer
    add_index :plays, :track_id
  end
end
