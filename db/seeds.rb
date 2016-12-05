# frozen_string_literal: true
# rubocop:disable Metrics/LineLength
unless Station.find_by_theme_type_and_slug(:genre, :classical)
  Station.create(
    name: 'Classical Music',
    slug: 'classical',
    api_query: 'DATA_PROVIDER:("National Library of Latvia" OR "Sächsische Landesbibliothek - Staats- und Universitätsbibliothek Dresden")',
    theme_type: :genre
  )
end

unless Station.find_by_theme_type_and_slug(:genre, :folk)
  Station.create(
    name: 'Folk and Traditional Music',
    slug: 'folk',
    api_query: '(DATA_PROVIDER:("LMTA (DIZI)" OR "Comhaltas Traditional Music Archive" OR "Irish Traditional Music Archive" OR "Tobar an Dualchais/Kist o Riches" OR "Cluj County Centre for the Preservation and Promotion of Traditional Culture" OR "Bibliothèque Medem - Maison de la Culture Yiddish" OR "Music Library of Greece of The Friends of Music Society" OR "Statsbiblioteket")) AND (what:(music OR música OR musique OR musik OR musica OR musicales OR muziek OR muzyka OR muzică OR "zenés előadás" OR "notated music" OR "traditional and folk music" OR "folk songs" OR "sheet music" OR score OR "musical Instrument" OR partitur OR partituras OR gradual OR libretto OR oper OR concerto OR symphony OR sonata OR fugue OR motet OR estampie OR "gregorian chant" OR saltarello OR organum OR ballade OR chanson OR galliard OR laude OR madrigal OR pavane OR ricercar OR tiento OR toccata OR cantata OR chaconne OR gavotte OR gigue OR minuet OR partita OR passacaglia OR sarabande OR sinfonia OR hymnes OR lied OR mazurka OR "music hall" OR quartet OR quintet OR requiem OR rhapsody OR rondo OR scherzo OR "sinfonia concertante" OR waltz OR ballet OR zanger OR chanteur OR chanteuse OR sång OR sångare OR sänger OR cantante OR sopran OR tenor OR sängerin OR composer OR compositeur OR orchestra OR orchester OR orkester OR orchestre OR concert OR concierto OR konsert OR konzert OR koncert OR gramophone OR "record player" OR phonograph OR fonograaf OR fonograf OR grammofon OR skivspelare OR "wax cylinder" OR jukebox OR "cassette deck" OR "cassette player"))',
    theme_type: :genre
  )
end

unless Station.find_by_theme_type_and_slug(:genre, :popular)
  Station.create(
    name: 'Popular Music',
    slug: 'popular',
    api_query: 'DATA_PROVIDER:"Internet Archive"',
    theme_type: :genre
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'National Library of Latvia')
  Station.create(
    name: 'National Library of Latvia',
    api_query: 'DATA_PROVIDER:"National Library of Latvia"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'Sächsische Landesbibliothek - Staats- und Universitätsbibliothek Dresden')
  Station.create(
    name: 'Sächsische Landesbibliothek - Staats- und Universitätsbibliothek Dresden',
    api_query: 'DATA_PROVIDER:"Sächsische Landesbibliothek - Staats- und Universitätsbibliothek Dresden"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'LMTA (DIZI)')
  Station.create(
    name: 'LMTA (DIZI)',
    api_query: 'DATA_PROVIDER:"LMTA (DIZI)"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'Comhaltas Traditional Music Archive')
  Station.create(
    name: 'Comhaltas Traditional Music Archive',
    api_query: 'DATA_PROVIDER:"Comhaltas Traditional Music Archive"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'Irish Traditional Music Archive')
  Station.create(
    name: 'Irish Traditional Music Archive',
    api_query: 'DATA_PROVIDER:"Irish Traditional Music Archive"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'Tobar an Dualchais/Kist o Riches')
  Station.create(
    name: 'Tobar an Dualchais/Kist o Riches',
    api_query: 'DATA_PROVIDER:"Tobar an Dualchais/Kist o Riches"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'Cluj County Centre for the Preservation and Promotion of Traditional Culture')
  Station.create(
    name: 'Cluj County Centre for the Preservation and Promotion of Traditional Culture',
    api_query: 'DATA_PROVIDER:"Cluj County Centre for the Preservation and Promotion of Traditional Culture"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'Bibliothèque Medem - Maison de la Culture Yiddish')
  Station.create(
    name: 'Bibliothèque Medem - Maison de la Culture Yiddish',
    api_query: 'DATA_PROVIDER:"Bibliothèque Medem - Maison de la Culture Yiddish"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'Music Library of Greece of The Friends of Music Society')
  Station.create(
    name: 'Music Library of Greece of The Friends of Music Society',
    api_query: 'DATA_PROVIDER:"Music Library of Greece of The Friends of Music Society"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'Statsbiblioteket')
  Station.create(
    name: 'Statsbiblioteket',
    api_query: 'DATA_PROVIDER:"Statsbiblioteket"',
    theme_type: :institution
  )
end

unless Station.find_by_theme_type_and_name(:institution, 'Internet Archive')
  Station.create(
    name: 'Internet Archive',
    api_query: 'DATA_PROVIDER:"Internet Archive"',
    theme_type: :institution
  )
end
# rubocop:enable Metrics/LineLength
