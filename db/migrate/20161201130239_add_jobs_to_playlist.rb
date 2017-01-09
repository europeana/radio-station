# frozen_string_literal: true
class AddJobsToPlaylist < ActiveRecord::Migration[5.0]
  def change
    add_column :playlists, :jobs, :integer, default: 0
  end
end
