class MakeTrackUuidOptional < ActiveRecord::Migration[5.0]
  def change
    change_column_null :tracks, :uuid, true
  end
end
