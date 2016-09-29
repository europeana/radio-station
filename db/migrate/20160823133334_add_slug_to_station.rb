# frozen_string_literal: true
class AddSlugToStation < ActiveRecord::Migration[5.0]
  def change
    add_column :stations, :slug, :text
    add_index :stations, :slug, unique: true
  end
end
