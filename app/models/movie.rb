class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_similar_movies(hash)
    list = Movie.find_all_by_director(hash.director)
    return list
  end
end