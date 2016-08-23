# frozen_string_literal: true
class CreateTracks < ActiveRecord::Migration[5.0]
  def change
    create_table :tracks do |t|
      t.belongs_to :tune, index: true
      t.belongs_to :playlist, index: true
      t.integer :order, null: false

      t.timestamps
    end
    add_index :tracks, :order
  end
end
