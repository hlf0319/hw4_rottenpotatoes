require 'spec_helper'

describe MoviesController do
  
  describe 'show test' do
    it 'show the correct id page' do
      fake_movie = mock('Movie', :id => '1')
      Movie.should_receive(:find).with('1').
        and_return(fake_movie)
      post :show, {:id => '1'}
      response.should render_template('movies/show')
      assigns(:movie).should == fake_movie
    end
  end
  
  describe 'index test' do
    it 'show the index page (dif sort, sort bt title)' do   
      post :index, {:sort => 'title', :ratings => ['G']}
      response.should redirect_to('/movies?ratings%5B%5D=G&sort=title')
    end
    
    it 'show the index page (dif sort, sort bt release_date)' do   
      post :index, {:sort => 'release_date', :ratings => ['PG']}
      response.should redirect_to('/movies?ratings%5B%5D=PG&sort=release_date')           
    end
    
    it 'show the index page (same sort, dif rating, sort bt release_date)' do   
      post :index, {:ratings => ['R']}
      response.should redirect_to('/movies?ratings%5B%5D=R')           
    end
 
    it 'show the index page (same sort, same rating, sort bt release_date)' do   
      post :index
      response.should render_template('index')           
    end   
  end
  
  
  describe 'create, edit, update, destroy test' do
    before :each do
      @fake_movie = {:title => 'Aladdin', :rating => 'G', :director => 'fake', :release_date => '25-Nov-1992'}
      @fake_result = mock('Movie', :id => '1', :title => 'Aladdin', :rating => 'G', :director => 'fake', :release_date => '25-Nov-1992')
    end
    it 'should create the movie page' do
      post :create, {:movie => @fake_movie}  
    end
    describe 'after valid creation' do
      before :each do
        post :create, {:movie => @fake_movie}    
      end
 
      it 'should appear the created the movie in home page' do
        response.should redirect_to('/movies')
      end
        
      it 'should go to the edit page of the movie' do
        Movie.should_receive(:find).with('1').
          and_return(@fake_result)
        post :edit, {:id => '1'}
        response.should render_template('edit')
      end
 
      it 'should update the movie page' do
        Movie.stub(:find).
          and_return(@fake_result)
        # @fake_result.should_recevie(:update_attributes!).with(@fake_movie).
          # and_return(true)
        post :update, {:id => '1', :movie => @fake_movie}
        response.should redirect_to('/movies/1')
      end

      it 'should destroy the movie page' do
        Movie.stub(:find).
          and_return(@fake_result)
        # @fake_result.should_recevie(:destroy).
          # and_return(true)
        post :destroy, {:id => '1'}
        response.should redirect_to('/movies')
      end
    end 
  end 
  
  describe 'similar movies(happy path)' do
    before :each do
      @fake_results1 = mock('Movie', :director => 'temp')
      @fake_results2 = [mock('Movie', :director => 'temp'), mock('Movie', :director => 'temp')]
    end
    it 'should call the model method that performs similar movies' do
      Movie.should_receive(:find).with('1').
        and_return(@fake_results1)
      Movie.should_receive(:find_all_by_director).with(@fake_results1.director).
        and_return(@fake_results2)
      post :similar_movies, {:id => '1'}
    end
    describe 'after valid find' do
      before :each do
        Movie.stub(:find).and_return(@fake_results1)
        Movie.stub(:find_all_by_director).and_return(@fake_results2)
        post :similar_movies, {:id => '1'}
      end
      it 'should select the similar movies template for rendering' do
        response.should render_template('similar_movies')
      end
      it 'should make the similar movies results available to that template' do
        assigns(:movie).should == @fake_results1
        assigns(:list).should == @fake_results2
      end
    end
  end
  
  describe 'similar movies(sad path)' do
    it 'should select the home page for rendering' do
      fake_results = mock('Movie', :title => 'no direcotr sad path', :director => '')
      Movie.should_receive(:find).with('1').
        and_return(fake_results)
      post :similar_movies, {:id => '1'}
      response.should redirect_to('/movies')
    end
    
  end
end