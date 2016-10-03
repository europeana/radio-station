# frozen_string_literal: true
class StationsController < ApplicationController
  JINGLE_RATE = 5

  def index
    @stations = Station.all
  end

  def show
    @station = Station.includes(:playlist).find_by_slug!(params[:id])
    @tracks = tracks
  end

  protected

  def tracks
    return [] if @station.playlist.nil?
    @station.playlist.tracks.includes(:tune, :origin).limit(limit).offset(offset)
  end

  # @fixme Doesn't work well with pagination
  def tracks_with_jingles
    tracks.to_a.tap do |jingly|
      jingly.each_with_index do |_track, i|
        jingly.insert(i, jingle(station: true)) if time_for_a_jingle?(i)
      end
      jingly.insert(0, jingle(station: false))
    end
  end

  def time_for_a_jingle?(i)
    (i > 0) && (i % JINGLE_RATE == 0)
  end

  def welcome_jingle_uri
    'https://s3.eu-central-1.amazonaws.com/europeana-radio/jingles/welcome.mp3'
  end

  def station_jingle_uri
    "https://s3.eu-central-1.amazonaws.com/europeana-radio/jingles/#{@station.slug}.mp3"
  end

  def jingle(station: false)
    uri = station ? station_jingle_uri : welcome_jingle_uri
    { 'uri' => uri }
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
