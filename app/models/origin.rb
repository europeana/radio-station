# frozen_string_literal: true
##
# An origin represents the source of one or more tunes: a Europeana record
class Origin < ApplicationRecord
  include EDM::Rights

  has_many :tunes, dependent: :destroy

  validates :europeana_record_id, uniqueness: true, presence: true
  validates :metadata, presence: true

  def self.creator(edm)
    return nil unless edm['dcCreator']
    %w(en mul def).each do |key|
      return edm['dcCreator'][key].first unless edm['dcCreator'][key].blank?
    end
    edm['dcCreator'].values.first.first
  end

  def web_resources
    metadata['aggregations'].map { |agg| agg['webResources'] }.flatten
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
