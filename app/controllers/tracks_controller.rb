# frozen_string_literal: true
class TracksController < ApplicationController
  # Deprecated, to be removed in future
  def play
    track = Track.find_by_uuid(params[:id])
    redirect_to play_tune_url(id: track.tune.uuid, station_id: track.station.id)
  end
end
