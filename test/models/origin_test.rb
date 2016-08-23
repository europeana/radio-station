require 'test_helper'

class OriginTest < ActiveSupport::TestCase
  should validate_presence_of(:europeana_record_id)
  should validate_uniqueness_of(:europeana_record_id)
  should validate_presence_of(:metadata)
  should have_many(:tunes).dependent(:destroy)
end
