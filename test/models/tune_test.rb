# frozen_string_literal: true
require 'test_helper'

class TuneTest < ActiveSupport::TestCase
  should validate_presence_of(:web_resource_uri)
  should validate_uniqueness_of(:web_resource_uri)
  should belong_to(:origin)
  should have_many(:plays).dependent(:nullify)
  should have_and_belong_to_many(:stations)
end
