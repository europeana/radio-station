# frozen_string_literal: true
class AddUuidToTune < ActiveRecord::Migration[5.0]
  def up
    add_column :tunes, :uuid, :string
    add_index :tunes, :uuid, unique: true

    Tune.where(uuid: nil).find_each do |tune|
      while tune.uuid.nil? || Tune.where(uuid: tune.uuid).count.positive?
        tune.uuid = SecureRandom.uuid
      end
      tune.save!
    end

    change_column :tunes, :uuid, :string, null: false
  end

  def down
    remove_column :tunes, :uuid
  end
end
