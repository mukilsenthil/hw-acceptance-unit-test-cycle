require 'rails_helper'

RSpec.describe Movie, type: :model do
  before(:all) do
    if Movie.where(:title => "Big Hero 6").empty?
      Movie.create(:title => "Big Hero 6",
                   :rating => "PG", :release_date => "2014-11-07")
    end

    Movie.create( title: "White House Down",
                  rating: "PG-13",
                  release_date: "2013-06-28",
                  director: "Roland Emmerich")

    Movie.create( title: "Kaithi",
                  rating: "A",
                  release_date: "2019-10-24",
                  director: "Lokesh Kanagaraj")

    Movie.create( title: "Enola Homes",
                  rating: "PG-13",
                  release_date: "23-Sep-2020",
                  director: "Harry Bradbeer")

    Movie.create( title: "2012",
                  rating: "PG-13",
                  release_date: "2009-11-13",
                  director: "Roland Emmerich")
  end

  describe "others_by_same_director method" do

    movie = Movie.find_by(title: "White House Down")

    it "returns all other movies by the same director" do
      other_movies = Movie.where(director: movie.director).where.not(id: movie.id)

      # Expect the result to match the other movies
      expect(movie.others_by_same_director).to match_array(other_movies)
    end

    it "does not return movies by other directors" do
      other_not_same_diro = Movie.where.not(director: movie.director)

      expect(movie.others_by_same_director).not_to match_array(other_not_same_diro)
    end
  end

end