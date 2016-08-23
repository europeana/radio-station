# frozen_string_literal: true
class Station < ApplicationRecord
  has_many :playlists

  validates :name, :api_query, presence: true, uniqueness: true
  validates :api_query, presence: true
end
