# frozen_string_literal: true
class PlaysController < ApplicationController
  def index
    @recent = Play.includes(track: [:tune, :station, :origin]).
              order('created_at DESC').limit(10)
  end
end
