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
      tune_ids_were = tune_ids
      tune_ids_are = playable_web_resources.map do |web_resource|
        create_or_update_tune_from_web_resource(web_resource).id
      end
      handle_lost_tunes(tune_ids_were - tune_ids_are)
    end
  end

  def handle_lost_tunes(ids)
    return if ids.blank?
    Tune.where(id: ids).update_all(origin_id: nil)
    Track.where(tune_id: ids).destroy_all
  end

  def create_or_update_tune_from_web_resource(web_resource)
    Tune.find_or_create_by(web_resource_uri: web_resource['about'], europeana_record_id: europeana_record_id).tap do |tune|
      tune.origin_id = id if tune.origin_id.nil?
      fail %(Tune exists for web resource "#{tune.web_resource_uri}" and origin "#{tune.origin.europeana_record_id}", but this origin is "#{europeana_record_id}") if tune.origin_id != id
      tune.metadata = web_resource
      tune.save!
    end
  end

  def playable_web_resources
    @playable_web_resources ||= begin
      playable = web_resources.select { |web_resource| web_resource_has_audio_mime_type?(web_resource) }
      if playable.present?
        playable
      else
        web_resources.select { |wr| wr['about'] == edm_is_shown_by }
      end
    end
  end

  def edm_is_shown_by
    metadata['aggregations'].first['edmIsShownBy']
  end

  def web_resources
    @web_resources ||= begin
      metadata['aggregations'].map { |agg| agg['webResources'] }.flatten.compact
    end
  end

  def web_resource_has_audio_mime_type?(web_resource)
    (web_resource['ebucoreHasMimeType'] || '').starts_with?('audio/')
  end

  def thumbnail
    @thumbnail ||= begin
      thumb_source = edm_object || edm_is_shown_by
      if thumb_source.nil?
        nil
      else
        "#{Rails.application.config.x.europeana_api_url}/thumbnail-by-url.json?type=SOUND&uri=" + CGI.escape(thumb_source)
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
