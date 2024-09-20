# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  Movie.destroy_all

  Movie.create(title: 'Big Hero 6',
               rating: 'PG',
               release_date: '2014-11-07',
               director: 'Don Hall, Chris Williams')

  Movie.create(title: 'White House Down',
               rating: 'PG-13',
               release_date: '2013-06-28',
               director: 'Roland Emmerich')

  Movie.create(title: 'Kaithi',
               rating: 'A',
               release_date: '2019-10-24')

  Movie.create(title: 'Stargate',
               rating: 'PG-13',
               release_date: '1994-10-28')

  Movie.create(title: 'Enola Homes',
               rating: 'PG-13',
               release_date: '23-Sep-2020',
               director: 'Harry Bradbeer')

  Movie.create(title: '2012',
               rating: 'PG-13',
               release_date: '2009-11-13',
               director: 'Roland Emmerich')

  describe 'when trying to find movies by the same director' do
    it 'returns a valid collection when a valid director is present' do
      movie = Movie.find_by(title: '2012')
      same_diro_movie = Movie.find_by(title: 'White House Down')
      get :show_by_director, params: { id: movie.id }

      expect(assigns(:movies)).to match_array(same_diro_movie)
    end

    it 'redirects to index with a warning when no director is present' do
      movie = Movie.find_by(title: 'Kaithi')
      get :show_by_director, params: { id: movie.id }

      expect(response).to redirect_to movies_path
      # expect(flash[:notice]).to eq("'#{movie.title}' has no director info")
    end
  end

  describe 'creates' do
    it 'movies with valid parameters_1' do
      get :create, params: { movie: { title: 'Threenagers', director: 'The Prof.s Ritchey',
                                      rating: 'G', release_date: '2015-01-20' } }
      expect(response).to redirect_to movies_path
      Movie.find_by(title: 'Threenagers').destroy
    end

    it 'movies with valid parameters_2' do
      get :create, params: { movie: { title: 'Threenagers', director: 'The Prof.s Ritchey',
                                      rating: 'G', release_date: '2015-01-20' } }
      expect(flash[:notice]).to match(/Threenagers was successfully created./)
      Movie.find_by(title: 'Threenagers').destroy
    end
  end

  describe 'updates' do
    it 'redirects to the movie details page and flashes a notice_1' do
      movie = Movie.create(title: 'Attack of the Munchkins', director: 'Sofia Grace',
                           rating: 'PG', release_date: '2024-08-19')
      get :update, params: { id: movie.id, movie: { description: 'A' } }
      expect(response).to redirect_to movie_path(movie)
      movie.destroy
    end

    it 'redirects to the movie details page and flashes a notice_2' do
      movie = Movie.create(title: 'Attack of the Munchkins', director: 'Sofia Grace',
                           rating: 'PG', release_date: '2024-08-19')
      get :update, params: { id: movie.id, movie: { description: 'A' } }
      expect(flash[:notice]).to match(/Attack of the Munchkins was successfully updated./)
      movie.destroy
    end

    it 'actually does the update' do
      movie = Movie.create(title: 'Seven Samurai', director: 'Yasujiro Ozu',
                           rating: 'PG', release_date: '1954-04-26')
      get :update, params: { id: movie.id, movie: { director: 'Akira Kurosawa' } }

      expect(assigns(:movie).director).to eq('Akira Kurosawa')
      movie.destroy
    end
  end

  describe 'destroys' do # new spec example
    it 'destroys the movie that is existing or created in the model_1' do
      movie_to_delete = Movie.create(title: 'Seven Samurai', director: 'Yasujiro Ozu',
                                     rating: 'PG', release_date: '1954-04-26')
      get :destroy, params: { id: movie_to_delete.id }

      expect(Movie.all).not_to match_array(movie_to_delete)
    end

    it 'destroys the movie that is existing or created in the model_2' do
      movie_to_delete = Movie.create(title: 'Seven Samurai', director: 'Yasujiro Ozu',
                                     rating: 'PG', release_date: '1954-04-26')
      get :destroy, params: { id: movie_to_delete.id }

      expect(flash[:notice]).to eq("Movie '#{movie_to_delete.title}' deleted.")
    end
  end
end
