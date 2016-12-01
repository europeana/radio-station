# frozen_string_literal: true
##
# A tune is one audio recording that can be played on the radio
class Tune < ApplicationRecord
  include EDM::Rights

  belongs_to :origin
  has_many :tracks, dependent: :destroy
  has_many :playlists, through: :tracks
  has_many :plays, dependent: :nullify
  has_and_belongs_to_many :stations

  validates :europeana_record_id, :web_resource_uri, :uuid, presence: true
  validates :web_resource_uri, uniqueness: { scope: :europeana_record_id }

  delegate :title, :thumbnail, :provider, to: :origin

  before_validation do |tune|
    while tune.uuid.nil?
      tune.uuid = SecureRandom.uuid
      if Tune.where(uuid: tune.uuid).count.positive?
        tune.uuid = nil
      end
    end
  end

  def uri
    web_resource_uri
  end

  def creator
    Origin.creator(metadata) || origin.creator
  end

  def edm_rights
    @edm_rights ||= begin
      if wr_rights = metadata['webResourceEdmRights']
        wr_rights['def'].first
      else
        origin.edm_rights
      end
    end
  end
end
