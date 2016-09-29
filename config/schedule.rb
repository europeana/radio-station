# frozen_string_literal: true
require File.expand_path('../boot', __FILE__)
require File.expand_path('../environment', __FILE__)
require 'clockwork'

include Clockwork

every(1.day, 'stations.playlists.refresh', at: ENV['SCHEDULE_PLAYLIST_REFRESH']) do
  Station.find_each do |station|
    RefreshStationPlaylistJob.perform_later(station.id)
  end
end
