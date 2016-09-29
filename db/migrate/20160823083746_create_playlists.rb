# frozen_string_literal: true
class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists do |t|
      t.integer :station_id
      t.boolean :live, default: false

      t.timestamps
    end

    add_foreign_key :playlists, :stations
  end
end
