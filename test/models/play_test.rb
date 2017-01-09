# frozen_string_literal: true
require 'test_helper'

class PlayTest < ActiveSupport::TestCase
  should belong_to(:station)
  should belong_to(:tune)
  should have_one(:origin).through(:tune)
end
