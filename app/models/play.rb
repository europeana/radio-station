# frozen_string_literal: true
class Play < ApplicationRecord
  belongs_to :station
  belongs_to :tune
  has_one :origin, through: :tune
end
