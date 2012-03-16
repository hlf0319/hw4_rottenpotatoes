require 'spec_helper'

describe Movie do
  describe 'check ratings' do
  
    it 'should list all ratings' do
      Movie.all_ratings
    end
  end
  
  describe 'check find_similar_movies' do
  
    it 'should return all similar movies' do
      fake_movie = mock('Movie', :director => "fake")
      fake_results = [mock('Movie'), mock('Movie')]
      Movie.should_receive(:find_all_by_director).with(fake_movie.director).
        and_return(fake_results)
      Movie.find_similar_movies(fake_movie)  
    end
  end 
  
  
  
end