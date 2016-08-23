# frozen_string_literal: true
class Station < ApplicationRecord
  has_and_belongs_to_many :tracks

  validates :name, :api_query, presence: true, uniqueness: true
  validates :api_query, presence: true
end
