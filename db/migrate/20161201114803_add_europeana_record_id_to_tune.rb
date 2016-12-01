# frozen_string_literal: true
class AddEuropeanaRecordIdToTune < ActiveRecord::Migration[5.0]
  def change
    add_column :tunes, :europeana_record_id, :string
    add_index :tunes, :europeana_record_id
    reversible do |dir|
      dir.up do
        execute('UPDATE tunes SET europeana_record_id=sub.europeana_record_id FROM (SELECT tunes.id tune_id, origins.europeana_record_id FROM origins INNER JOIN tunes ON origins.id=tunes.origin_id) sub WHERE tunes.id=sub.tune_id')
      end
    end
  end
end
