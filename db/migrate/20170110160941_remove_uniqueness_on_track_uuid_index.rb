# frozen_string_literal: true
class RemoveUniquenessOnTrackUuidIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :tracks, :uuid
    add_index :tracks, :uuid
  end
end
