# frozen_string_literal: true
YAML.load_file(File.expand_path('../seeds/stations.yml', __FILE__)).each do |sdata|
  station = Station.find_or_create_by(theme_type: sdata[:theme_type], name: sdata[:name])
  station.update_attributes(api_query: sdata[:api_query])
end
