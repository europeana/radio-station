# frozen_string_literal: true
class AssociatePlaysWithTracks < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        Play.destroy_all
      end
    end

    remove_index :plays, :europeana_record_id
    remove_index :plays, :web_resource_uri
    remove_index :plays, :provider
    remove_index :plays, :station
    remove_column :plays, :europeana_record_id, :string
    remove_column :plays, :web_resource_uri, :string
    remove_column :plays, :provider, :string
    remove_column :plays, :station, :string
    remove_column :plays, :title, :text
    add_reference :plays, :track, index: true
  end
end
