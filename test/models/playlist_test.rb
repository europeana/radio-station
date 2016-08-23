# frozen_string_literal: true
require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  should belong_to(:station)
  should have_and_belong_to_many(:tracks)
end
