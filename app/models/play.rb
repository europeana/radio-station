class Play < ApplicationRecord
  belongs_to :track

  validates :track_id, presence: true
end
