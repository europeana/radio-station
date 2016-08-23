# frozen_string_literal: true
class StationsController < ApplicationController
  def index
    @stations = Station.all
  end

  def show
    @station = Station.find_by_slug(params[:id])
  end
end
