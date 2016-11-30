# frozen_string_literal: true
##
# An origin represents the source of one or more tunes: a Europeana record
class Origin < ApplicationRecord
  include EDM::Rights

  has_many :tunes, dependent: :nullify

  validates :europeana_record_id, uniqueness: true, presence: true
  validates :metadata, presence: true

  after_save :extract_tunes_from_metadata

  def self.creator(edm)
    return nil unless edm['dcCreator']
    %w(en mul def).each do |key|
      return edm['dcCreator'][key].first unless edm['dcCreator'][key].blank?
    end
    edm['dcCreator'].values.first.first
  end

  def extract_tunes_from_metadata
    self.transaction do
      tune_ids_were = tunes.map(&:id)
      tune_ids_are = playable_web_resources.map do |web_resource|
        tune = Tune.find_or_create_by(web_resource_uri: web_resource['about'], origin_id: id)
        tune.metadata = web_resource
        tune.save!
        tune.id
      end
      lost_tune_ids = tune_ids_were - tune_ids_are
      unless lost_tune_ids.blank?
        Tune.where(id: lost_tune_ids).update_all(origin_id: nil)
        Track.where(tune_id: lost_tune_ids).destroy_all
      end
    end
  end

  def playable_web_resources
    web_resources.select do |web_resource|
      web_resource_has_audio_mime_type?(web_resource) &&
        web_resource_has_minimum_duration?(web_resource)
    end
  end

  def web_resources
    metadata['aggregations'].map { |agg| agg['webResources'] }.flatten.compact
  end

  def web_resource_has_audio_mime_type?(web_resource)
    (web_resource['ebucoreHasMimeType'] || '').starts_with?('audio/')
  end

  def web_resource_has_minimum_duration?(web_resource)
    (web_resource['ebucoreDuration'] || 0).to_i >= 180_000
  end

  def thumbnail
    @thumbnail ||= begin
      if edm_object.nil?
        nil
      else
        "#{Rails.application.config.x.europeana_api_url}/thumbnail-by-url.json?type=SOUND&uri=" + CGI.escape(edm_object)
      end
    end
  end

  def edm_object
    @edm_object ||= metadata['aggregations'].first['edmObject']
  end

  def title
    metadata['title'].first
  end

  def proxy(europeana:)
    metadata['proxies'].detect { |proxy| proxy['europeanaProxy'] == europeana }
  end

  def creator
    europeana_proxy = proxy(europeana: false)
    self.class.creator(europeana_proxy) || 'Unknown'
  end

  def edm_rights
    @edm_rights ||= metadata['aggregations'].first['edmRights']['def'].first
  end

  def provider
    @provider ||= metadata['aggregations'].first['edmProvider']['def'].first
  end
end
