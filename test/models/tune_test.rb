require 'test_helper'

class TuneTest < ActiveSupport::TestCase
  should validate_presence_of(:web_resource_uri)
  should validate_uniqueness_of(:web_resource_uri)
  should validate_presence_of(:origin_id)
  should belong_to(:origin)
end
