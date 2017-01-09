# frozen_string_literal: true
class AddMetadataToTune < ActiveRecord::Migration[5.0]
  class Tune < ApplicationRecord; end

  def change
    add_column :tunes, :metadata, :json
    reversible do |dir|
      dir.up do
        Tune.find_each do |tune|
          tune.metadata = tune.origin.web_resources.detect { |wr| wr['about'] == tune.web_resource_uri }
          tune.save!
        end
      end
    end
  end
end
