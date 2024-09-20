# frozen_string_literal: true

# this is movie model class
class Movie < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true

  def others_by_same_director
    Movie.where(director:).where.not(id:)
  end

  def sort_rating_asc
    @sort_column = 'rating'
    @sort_direction = 'asc'
    Movie.order("#{@sort_column} #{@sort_direction}")
  end
end
