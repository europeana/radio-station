class TunesController < ApplicationController
  def play
    tune = Tune.find_by_uuid!(params[:id])
    station_id = Station.find_by_id(params[:station_id])
    Play.create(station: station_id, tune: tune)
    redirect_to tune.uri
  end
end
