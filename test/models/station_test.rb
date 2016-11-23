# frozen_string_literal: true
require 'test_helper'

class StationTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).scoped_to(:theme_type)
  should validate_presence_of(:api_query)
  should validate_presence_of(:slug)
  should validate_uniqueness_of(:slug).scoped_to(:theme_type)
  should have_many(:playlists).dependent(:destroy)
  should define_enum_for(:theme_type).with([:genre, :institution])

  test 'should generate slug from name' do
    station = Station.new(name: 'Jazz Music')
    station.valid?
    assert_equal('jazz-music', station.slug)
  end

  test 'should transliterate name for slug' do
    station = Station.new(name: 'Français and Español')
    station.valid?
    assert_equal('francais-and-espanol', station.slug)
  end

  test 'should use theme type and slug for param' do
    station = Station.new(slug: 'folk', theme_type: :genre)
    assert_equal('genres/folk', station.to_param)
  end
end
