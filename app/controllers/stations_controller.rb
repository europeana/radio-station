# frozen_string_literal: true
class StationsController < ApplicationController
  def index
    @stations = Station.all
  end

  def show
    @station = Station.find_by_slug(params[:id])
    @tracks = @station.playlist.tracks.limit(limit).offset(offset)
  end

  protected

  def limit
    l = (params[:rows] || 12).to_i
    l > 100 ? 100 : l
  end

  def offset
    (params[:start] || 0).to_i
  end
end
