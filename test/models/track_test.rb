# frozen_string_literal: true
require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  should validate_presence_of(:europeana_id)
  should validate_presence_of(:web_resource_uri)
  should validate_presence_of(:metadata)
  should have_and_belong_to_many(:stations)
end
