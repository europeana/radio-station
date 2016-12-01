# frozen_string_literal: true
require File.expand_path('../boot', __FILE__)
require File.expand_path('../environment', __FILE__)
require 'clockwork'

include Clockwork

# Disabled while available institutions are hard-coded via db/seeds.rb
# every(1.day, 'stations.institutions.refresh', at: ENV['SCHEDULE_INSTITUTION_REFRESH']) do
#   RefreshInstitutionsJob.perform_later
# end

every(1.day, 'stations.playlists.refresh', at: ENV['SCHEDULE_PLAYLIST_REFRESH']) do
  Station.find_each do |station|
    GenerateNewStationPlaylistJob.perform_later(station.id)
  end
end

every(1.week, 'stations.tunes.refresh', at: ENV['SCHEDULE_TUNES_REFRESH']) do
  Station.find_each do |station|
    RefreshStationTunesJob.perform_later(station.id)
  end
end

every(1.week, 'origins.refresh', at: ENV['SCHEDULE_ORIGINS_REFRESH']) do
  UpdateOrDeleteOriginsJob.perform_later
end
