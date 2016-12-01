# frozen_string_literal: true
class RemoveUniquenessFromTuneWebResourceUriIndex < ActiveRecord::Migration[5.0]
  def up
    remove_index :tunes, :web_resource_uri
    add_index :tunes, :web_resource_uri
  end

  def down
    remove_index :tunes, :web_resource_uri
    add_index :tunes, :web_resource_uri, unique: true
  end
end
