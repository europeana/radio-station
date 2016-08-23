# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
classical = Station.create(name: 'Classical Music', api_query: 'europeana_collectionName:"2048401_Ag_DE_DDB_eseslub" OR (europeana_collectionName:"2059219_Ag_EU_eSOUNDS_1015_BNF" AND what:"musique classique") OR (europeana_collectionName:"2059201_Ag_EU_eSOUNDS_1003_Latvia" AND what:(operas OR arranged))')

folk = Station.create(name: 'Folk and Traditional Music', api_query: '(europeana_collectionName:"282059213_Ag_EU_eSOUNDS_1013_ITMA" AND TYPE:"SOUND") OR (europeana_collectionName:"2059219_Ag_EU_eSOUNDS_1015_BNF" AND what:"musique traditionnelles") OR europeana_collectionName:"09335_Ag_EU_Judaica_cfmj4" OR europeana_collectionName:"2022420_Ag_RO_Elocal_cjcpctmu" OR europeana_collectionName:"2059206_Ag_EU_eSOUNDS_1011_FMS"')
