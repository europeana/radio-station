# frozen_string_literal: true
# rubocop:disable Metrics/LineLength
class UpdateGenreQueries < ActiveRecord::Migration[5.0]
  def up
    station = Station.find_by_theme_type_and_slug(:genre, :classical)
    unless station.nil?
      station.update_attributes(api_query: 'DATA_PROVIDER:("National Library of Latvia" OR "Sächsische Landesbibliothek - Staats- und Universitätsbibliothek Dresden")')
    end

    station = Station.find_by_theme_type_and_slug(:genre, :folk)
    unless station.nil?
      station.update_attributes(api_query: '(DATA_PROVIDER:("LMTA (DIZI)" OR "Comhaltas Traditional Music Archive" OR "Irish Traditional Music Archive" OR "Tobar an Dualchais/Kist o Riches" OR "Cluj County Centre for the Preservation and Promotion of Traditional Culture" OR "Bibliothèque Medem - Maison de la Culture Yiddish" OR "Music Library of Greece of The Friends of Music Society" OR "Statsbiblioteket")) AND (what:(music OR música OR musique OR musik OR musica OR musicales OR muziek OR muzyka OR muzică OR "zenés előadás" OR "notated music" OR "traditional and folk music" OR "folk songs" OR "sheet music" OR score OR "musical Instrument" OR partitur OR partituras OR gradual OR libretto OR oper OR concerto OR symphony OR sonata OR fugue OR motet OR estampie OR "gregorian chant" OR saltarello OR organum OR ballade OR chanson OR galliard OR laude OR madrigal OR pavane OR ricercar OR tiento OR toccata OR cantata OR chaconne OR gavotte OR gigue OR minuet OR partita OR passacaglia OR sarabande OR sinfonia OR hymnes OR lied OR mazurka OR "music hall" OR quartet OR quintet OR requiem OR rhapsody OR rondo OR scherzo OR "sinfonia concertante" OR waltz OR ballet OR zanger OR chanteur OR chanteuse OR sång OR sångare OR sänger OR cantante OR sopran OR tenor OR sängerin OR composer OR compositeur OR orchestra OR orchester OR orkester OR orchestre OR concert OR concierto OR konsert OR konzert OR koncert OR gramophone OR "record player" OR phonograph OR fonograaf OR fonograf OR grammofon OR skivspelare OR "wax cylinder" OR jukebox OR "cassette deck" OR "cassette player"))')
    end
  end
end
# rubocop:enable Metrics/LineLength
