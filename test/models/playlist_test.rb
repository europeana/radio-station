# frozen_string_literal: true
require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  should belong_to(:station)
  should have_many(:tracks).dependent(:destroy)
  should validate_presence_of(:station_id)
end
