# frozen_string_literal: true
class StationsController < ApplicationController
  def index
    @stations = Station.all
  end

  def show
    @station = Station.includes(:playlist).find_by_theme_type_and_slug!(params[:theme_type], params[:slug])
    @tracks = tracks
  end

  protected

  def tracks
    return [] if @station.playlist.nil?
    @station.playlist.tracks.includes(:tune, :origin).limit(limit).offset(offset)
  end

  def limit
    l = (params[:rows] || 12).to_i
    l > 100 ? 100 : l
  end

  def offset
    o = (params[:start] || 0).to_i
    o -= @station.playlist_length while o >= @station.playlist_length
    o
  end
end
