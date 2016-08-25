class AddUuidToTune < ActiveRecord::Migration[5.0]
  def change
    add_column :tunes, :uuid, :string
    add_index :tunes, :uuid, unique: true

    reversible do |dir|
      dir.up do
        Tune.where(uuid: nil).find_each do |tune|
          while tune.uuid.nil? || Tune.where(uuid: tune.uuid).count > 0
            tune.uuid = SecureRandom.uuid
          end
          tune.save!
        end
      end
    end

    change_column :tunes, :uuid, :string, null: false
  end
end
