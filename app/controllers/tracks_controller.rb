# frozen_string_literal: true
class TracksController < ApplicationController
  def play
    track = Track.find_by_uuid(params[:id])
    track.log_play
    redirect_to track.uri
  end
end
