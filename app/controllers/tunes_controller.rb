class TunesController < ApplicationController
  def play
    tune = Tune.find_by_uuid(params[:id])
    redirect_to tune.uri
  end
end
