# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: redirect('stations.json')

  resources :stations, only: %w(index show)

  resources :tunes, only: [] do
    get :play, on: :member
  end
end
