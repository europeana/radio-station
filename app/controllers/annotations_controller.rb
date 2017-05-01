# frozen_string_literal: true
class AnnotationsController < ApplicationController
  rescue_from Europeana::API::Errors::Base do |exception|
    api_response = exception.faraday_response.body
    response = if api_response.is_a?(Hash)
                 api_response.without('apikey')
               else
                 { success: false, error: exception.message }
               end
    render json: response, status: exception.faraday_response.status
  end

  def index
    tune = Tune.find_by_uuid!(params[:tune_id])
    render json: annotations_for_tune(tune).to_json
  end

  def create
    tune = Tune.find_by_uuid!(params[:tune_id])
    payload = JSON.parse(request.body.read).merge(target: target_uri(tune), generator: generator)

    api_params = annotations_api_env_params.merge(userToken: ENV['EUROPEANA_ANNOTATIONS_API_USER_TOKEN'],
                                                  body: payload.to_json)

    response = Europeana::API.annotation.create(api_params)
    render json: response.to_json
  end

  protected

  def generator
    {
      id: 'http://radio-player.europeana.eu/',
      name: 'Europeana.eu radio',
      type: 'Software'
    }
  end

  # @todo remove target_id fallback when target_uri field name change deployed
  #   to production Annotations API
  def annotations_for_tune(tune)
    begin
      search = Europeana::API.annotation.search(annotations_api_search_params(tune))
    rescue Europeana::API::Errors::ServerError => error
      if error.message == 'An unexpected server exception occured! undefined field target_uri'
        search = Europeana::API.annotation.search(annotations_api_search_params(tune, target_field_name: 'target_id'))
      else
        raise
      end
    end

    return [] unless search['items']
    return [search['items']].flatten unless search['items'].any? { |item| item.is_a?(String) }

    Europeana::API.in_parallel do |queue|
      search['items'].each do |item|
        provider, id = item.split('/')[-2..-1]
        queue.add(:annotation, :fetch, annotations_api_fetch_params(provider, id))
      end
    end
  end

  def target_uri(tune)
    "http://data.europeana.eu/item#{tune.europeana_record_id}"
  end

  def annotations_api_search_params(tune, target_field_name: 'target_uri')
    {
      query: %(#{target_field_name}:"#{target_uri(tune)}"),
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
