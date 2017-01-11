# frozen_string_literal: true
class AddBothKeysIndexToStationsTunes < ActiveRecord::Migration[5.0]
  def change
    add_index :stations_tunes, [:station_id, :tune_id]
  end
end
