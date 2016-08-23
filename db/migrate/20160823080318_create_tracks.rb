# frozen_string_literal: true
class CreateTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks do |t|
      t.string :europeana_id
      t.string :web_resource_uri
      t.json :metadata

      t.timestamps
    end
    add_index :tracks, :europeana_id
    add_index :tracks, :web_resource_uri
    add_index :tracks, [:europeana_id, :web_resource_uri], unique: true
  end
end
