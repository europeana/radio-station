# frozen_string_literal: true
class CreateStations < ActiveRecord::Migration[5.0]
  def change
    create_table :stations do |t|
      t.string :name
      t.text :api_query

      t.timestamps
    end
  end
end
