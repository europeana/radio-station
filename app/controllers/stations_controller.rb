# frozen_string_literal: true
class StationsController < ApplicationController
  def index
    @stations = Station.all
  end

  def show
    @station = Station.find_by_slug!(params[:id])
    @tracks = tracks
  end

  protected

  def tracks
    if @station.playlist.nil?
      []
    else
      @station.playlist.tracks.limit(limit).offset(offset)
    end
  end

  def limit
    l = (params[:rows] || 12).to_i
    l > 100 ? 100 : l
  end

  def offset
    o = (params[:start] || 0).to_i
    while o >= @station.playlist_length
      o = o - @station.playlist_length
    end
    o
  end
end
