# frozen_string_literal: true
class RefreshInstitutionsJob < ApplicationJob
  queue_as :api_facets

  # @todo Handle stored institutions no longer in the response... how?
  def perform
    institutions.each do |institution|
      if Station.find_by(find_attributes(institution)).nil?
        Station.create!(create_attributes(institution))
      end
    end
  end

  protected

  def institutions
    api_response['facets'].first['fields'].map { |ff| ff['label'] }
  end

  def find_attributes(institution)
    { theme_type: :institution, name: institution }
  end

  def create_attributes(institution)
    find_attributes(institution).merge(
      api_query: %(DATA_PROVIDER:"#{institution}")
    )
  end

  def api_response
    Europeana::API.record.search(api_search_params)
  end

  def api_search_params
    {
      query: 'DATA_PROVIDER:("National Library of Latvia" OR "Sächsische Landesbibliothek - Staats- und Universitätsbibliothek Dresden" OR "LMTA (DIZI)" OR "Comhaltas Traditional Music Archive" OR "Irish Traditional Music Archive" OR "Tobar an Dualchais/Kist o Riches" OR "Cluj County Centre for the Preservation and Promotion of Traditional Culture" OR "Bibliothèque Medem - Maison de la Culture Yiddish" OR "Music Library of Greece of The Friends of Music Society" OR "Statsbiblioteket" OR "Internet Archive")',
      rows: 0,
      profile: 'minimal,facets,params',
      facet: 'DATA_PROVIDER',
      'f.DATA_PROVIDER.facet.limit' => 1_000,
      qf: api_playable_audio_qf_params
    }
  end
end
