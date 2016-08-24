# frozen_string_literal: true
require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  should belong_to(:tune)
  should belong_to(:playlist)
  should validate_presence_of(:tune_id)
  should validate_presence_of(:playlist_id)
  should validate_uniqueness_of(:tune_id).scoped_to(:playlist_id)
  should validate_uniqueness_of(:order).scoped_to(:playlist_id)
end
