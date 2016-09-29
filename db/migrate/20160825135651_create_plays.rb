# frozen_string_literal: true
class CreatePlays < ActiveRecord::Migration[5.0]
  def change
    create_table :plays do |t|
      t.string :europeana_record_id
      t.string :web_resource_uri
      t.string :provider
      t.string :station
      t.text :title

      t.timestamps
    end
    add_index :plays, :europeana_record_id
    add_index :plays, :web_resource_uri
    add_index :plays, :provider
    add_index :plays, :station
  end
end
