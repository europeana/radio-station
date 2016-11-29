# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: redirect('stations.json')

  resources :stations, only: :index
  Station.theme_types.keys.each do |theme_type|
    get "stations/#{theme_type.pluralize}",
        to: 'stations#index', defaults: { theme_type: theme_type }, as: "#{theme_type}_stations"
    get "stations/#{theme_type.pluralize}/:slug",
        to: 'stations#show', defaults: { theme_type: theme_type }, as: "#{theme_type}_station"
  end

  get '/stations/classical(.:format)', to: redirect('/stations/genres/classical.%{format}')
  get '/stations/folk(.:format)', to: redirect('/stations/genres/folk.%{format}')

  resources :tunes, only: [] do
    get :play, on: :member
  end

  # Deprecated, to be removed in future
  resources :tracks, only: [] do
    get :play, on: :member
  end

  resources :plays, only: :index
end
