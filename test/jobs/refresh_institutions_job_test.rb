require 'test_helper'

class RefreshInstitutionsJobTest < ActiveJob::TestCase
  def setup
    stub_request(:get, 'https://www.europeana.eu/api/v2/search.json').
      with(query: hash_including({ query: '*:*', facet: 'DATA_PROVIDER' })).
      to_return(body: '{"success": true, "facets": [{"name": "DATA_PROVIDER", "fields": [{"label": "Internet Archive", "count": 3344}, {"label": "LMTA (DIZI)", "count": 1160}]}]}', headers: { 'Content-Type' => 'application/json' })
  end

  test 'that an API query is made' do
    RefreshInstitutionsJob.perform_now
    assert_requested(:get, %r{\Ahttps://www.europeana.eu/api/v2/search.json}, times: 1)
  end

  test 'that Station records are created' do
    assert_equal(0, Station.where(theme_type: :institution).count)
    RefreshInstitutionsJob.perform_now
    assert_equal(2, Station.where(theme_type: :institution).count)
  end
end
