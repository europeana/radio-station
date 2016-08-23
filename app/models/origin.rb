# frozen_string_literal: true
##
# An origin represents the source of one or more tunes: a Europeana record
class Origin < ApplicationRecord
  has_many :tunes, dependent: :destroy

  validates :europeana_record_id, uniqueness: true, presence: true
  validates :metadata, presence: true

  def web_resources
    metadata['aggregations'].map { |agg| agg['webResources'] }.flatten
  end
end
