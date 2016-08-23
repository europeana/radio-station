# frozen_string_literal: true
require 'test_helper'

class StationTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should validate_presence_of(:api_query)
  should validate_presence_of(:slug)
  should validate_uniqueness_of(:slug)
  should have_many(:playlists).dependent(:destroy)
end
