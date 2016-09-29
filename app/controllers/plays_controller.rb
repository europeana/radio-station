# frozen_string_literal: true
class PlaysController < ApplicationController
  def index
    @recent = Play.order('created_at DESC').limit(10)
  end
end
