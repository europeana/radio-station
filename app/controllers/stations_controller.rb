# frozen_string_literal: true
class StationsController < ApplicationController
  def index
    conditions = params.key?(:theme_type) ? { theme_type: params[:theme_type] } : nil
    @stations = Station.where(conditions).includes(:playlist).select do |station|
      station.playlist.present?
    end
  end

  def show
    @station = Station.includes(:playlist).find_by_theme_type_and_slug!(params[:theme_type], params[:slug])
    @tracks = paginated_station_tracks
    @total_tracks = total_track_count
  end

  protected

  def paginated_station_tracks
    station_tracks.nil? ? [] : station_tracks.limit(limit).offset(offset)
  end

  def total_track_count
    station_tracks.nil? ? 0 : station_tracks.count
  end

  def station_tracks
    @station_tracks ||= begin
      return nil if @station.playlist.nil?

      station_tracks = @station.playlist.tracks.includes(:tune, :origin)

      # Filter by another station's playlist, e.g. for all of one institution's
      # tracks of a particular genre
      %i(genre institution).each do |theme_type|
        next unless params[theme_type]
        other_station = Station.find_by_theme_type_and_slug!(theme_type, params[theme_type])
        return nil unless other_station.playlist.present?
        station_tracks = station_tracks.where('tune_id IN (SELECT tunes.id FROM tunes INNER JOIN tracks ON tunes.id=tracks.tune_id WHERE tracks.playlist_id=?)', other_station.playlist.id)
      end

      station_tracks
    end
  end

  def limit
    l = (params[:rows] || 12).to_i
    l > 100 ? 100 : l
  end

  def offset
    o = (params[:start] || 0).to_i
    o -= @station.playlist_length while o.nonzero? && o >= @station.playlist_length
    o
  end
end
