# frozen_string_literal: true

Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root to: redirect('/movies')
  get ':id/show_by_director', to: 'movies#show_by_director', as: :show_by_director
end
