# frozen_string_literal: true
class PlaysController < ApplicationController
  def index
    @recent = Play.includes(:tune, :station, :origin).
              order('created_at DESC').limit(10)
  end
end
