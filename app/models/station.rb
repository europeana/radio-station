class Station < ApplicationRecord
  validates :name, :api_query, presence: true, uniqueness: true
  validates :api_query, presence: true
end
