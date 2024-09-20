# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Movie, type: :model do
  if described_class.where(title: 'Big Hero 6').empty?
    described_class.create(title: 'Big Hero 6',
                           rating: 'PG', release_date: '2014-11-07')
  end

  described_class.create(title: 'White House Down',
                         rating: 'PG-13',
                         release_date: '2013-06-28',
                         director: 'Roland Emmerich')

  described_class.create(title: 'Kaithi',
                         rating: 'A',
                         release_date: '2019-10-24',
                         director: 'Lokesh Kanagaraj')

  described_class.create(title: 'Enola Homes',
                         rating: 'PG-13',
                         release_date: '23-Sep-2020',
                         director: 'Harry Bradbeer')

  described_class.create(title: '2012',
                         rating: 'R',
                         release_date: '2009-11-13',
                         director: 'Roland Emmerich')

  describe 'others_by_same_director method' do
    movie = described_class.find_by(title: 'White House Down')

    it 'returns all other movies by the same director' do
      other_movies = described_class.where(director: movie.director).where.not(id: movie.id)

      # Expect the result to match the other movies
      expect(movie.others_by_same_director).to match_array(other_movies)
    end

    it 'does not return movies by other directors' do
      other_not_same_diro = described_class.where.not(director: movie.director)

      expect(movie.others_by_same_director).not_to match_array(other_not_same_diro)
    end
  end

  describe 'sort the model' do # new spec example
    movie = described_class.find_by(title: 'White House Down')

    it 'returns the movie order to be sorted in rating ascending' do
      order_movie = movie.sort_rating_asc
      expect(order_movie.index(described_class.find_by(title: 'Kaithi')))
        .to be < order_movie.index(described_class.find_by(title: '2012'))
    end
  end

  describe 'uniqueness of title' do
    it 'is not valid with a duplicate title' do
      movie = described_class.create(title: 'Dada', rating: 'G', release_date: '2023-02-10',
                                     director: 'Ganesh K Babu')
      duplicate_movie = described_class.new(title: 'Dada', rating: 'G', release_date: '2023-02-10')
      expect(duplicate_movie).not_to be_valid
      movie.destroy
    end
  end
end
