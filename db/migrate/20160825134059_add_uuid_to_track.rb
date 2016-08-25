class AddUuidToTrack < ActiveRecord::Migration[5.0]
  def up
    add_column :tracks, :uuid, :string
    add_index :tracks, :uuid, unique: true

    Track.where(uuid: nil).find_each do |track|
      while track.uuid.nil? || Track.where(uuid: track.uuid).count > 0
        track.uuid = SecureRandom.uuid
      end
      track.save!
    end

    change_column :tracks, :uuid, :string, null: false
  end

  def down
    remove_column :tracks, :uuid
  end
end
