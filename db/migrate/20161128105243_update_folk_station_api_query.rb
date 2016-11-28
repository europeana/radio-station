# frozen_string_literal: true
# rubocop:disable Metrics/LineLength
class UpdateFolkStationApiQuery < ActiveRecord::Migration[5.0]
  def up
    station = Station.find_by_theme_type_and_slug(:genre, :folk)
    return if station.nil?
    station.update_attributes(api_query: 'DATA_PROVIDER:"Comhaltas Traditional Music Archive" OR DATA_PROVIDER:"LMTA (DIZI)" OR DATA_PROVIDER:"Irish Traditional Music Archive"')
  end

  def down
    station = Station.find_by_theme_type_and_slug(:genre, :folk)
    return if station.nil?
    station.update_attributes(api_query: '(europeana_collectionName:"282059213_Ag_EU_eSOUNDS_1013_ITMA" AND TYPE:"SOUND") OR (europeana_collectionName:"2059219_Ag_EU_eSOUNDS_1015_BNF" AND what:"musique traditionnelles") OR europeana_collectionName:"09335_Ag_EU_Judaica_cfmj4" OR europeana_collectionName:"2022420_Ag_RO_Elocal_cjcpctmu" OR europeana_collectionName:"2059206_Ag_EU_eSOUNDS_1011_FMS"')
  end
end
# rubocop:enable Metrics/LineLength
