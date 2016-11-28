# frozen_string_literal: true
# rubocop:disable Metrics/LineLength
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
unless Station.find_by_theme_type_and_slug(:genre, :classical)
  Station.create(
    name: 'Classical Music',
    slug: 'classical',
    api_query: 'europeana_collectionName:"2048401_Ag_DE_DDB_eseslub" OR (europeana_collectionName:"2059219_Ag_EU_eSOUNDS_1015_BNF" AND what:"musique classique") OR (europeana_collectionName:"2059201_Ag_EU_eSOUNDS_1003_Latvia" AND what:(operas OR arranged))',
    theme_type: :genre
  )
end

unless Station.find_by_theme_type_and_slug(:genre, :folk)
  Station.create(
    name: 'Folk and Traditional Music',
    slug: 'folk',
    api_query: 'DATA_PROVIDER:"Comhaltas Traditional Music Archive" OR DATA_PROVIDER:"LMTA (DIZI)" OR DATA_PROVIDER:"Irish Traditional Music Archive"',
    theme_type: :genre
  )
end

unless Station.find_by_theme_type_and_slug(:genre, :popular)
  Station.create(
    name: 'Popular Music',
    slug: 'popular',
    api_query: 'provider_aggregation_edm_dataProvider:"Internet Archive"',
    theme_type: :genre
  )
end
# rubocop:enable Metrics/LineLength
