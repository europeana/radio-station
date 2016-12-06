# frozen_string_literal: true
class TunesController < ApplicationController
  def play
    tune = Tune.find_by_uuid!(params[:id])
    station_id = Station.find_by_id(params[:station_id])
    Play.create(station: station_id, tune: tune)
    redirect_to tune.uri
  end

  def annotations
    tune = Tune.find_by_uuid!(params[:id])
    render json: annotations_for_tune(tune).to_json
  end

  protected

  def annotations_for_tune(tune)
    search = Europeana::API.annotation.search(annotations_api_search_params(tune))

    Europeana::API.in_parallel do |queue|
      search['items'].each do |item|
        provider, id = item.split('/')[-2..-1]
        queue.add(:annotation, :fetch, annotations_api_fetch_params(provider, id))
      end
    end
  end

  def annotations_api_search_params(tune)
    {
      query: %(target_id:"http://data.europeana.eu/item#{tune.europeana_record_id}"),
      pageSize: 100
    }.merge(annotations_api_env_params)
  end

  def annotations_api_fetch_params(provider, id)
    {
      provider: provider,
      id: id
    }.merge(annotations_api_env_params)
  end

  def annotations_api_env_params
    {
      wskey: ENV['EUROPEANA_ANNOTATIONS_API_KEY'] || Europeana::API.key,
      api_url: ENV['EUROPEANA_ANNOTATIONS_API_URL'] || Europeana::API.url
    }
  end
end
