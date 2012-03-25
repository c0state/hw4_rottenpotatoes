require 'spec_helper'
require 'factory_girl_rails'

describe MoviesController do
  before(:each) do
    @movie = mock_model(Movie, :id => "1", :title => 'Movie 1', :director => 'John Doe')
    Movie.stub(:find).with(@movie.id).and_return(@movie)
  end

  describe 'add director to movie' do
    it 'should make director field available to show details page' do
      @movie.stub(:update_attributes!).and_return(true)
      put :update, :id => @movie.id, :movie => {}
      response.should redirect_to(@movie)
      assigns[:movie].director.should == 'John Doe'
    end
  end

  describe 'find movies with same director' do
    it 'should go to show movies with same director action' do
      post :same_director, { :id => @movie.id }
    end

    it 'should show same directors view' do
      Movie.stub(:find_with_same_director).with(@movie.director).and_return([@movie])
      post :same_director, { :id => @movie.id }
      response.should render_template('same_director')
    end

    it 'should provide movies list for known director' do
      @movie2 = mock_model(Movie, :id => "2", :title => 'Movie 2', :director => 'John Doe')
      @movie3 = mock_model(Movie, :id => "3", :title => 'Movie 3', :director => 'John Doe')
      Movie.stub(:find_with_same_director).with(@movie.director).and_return([@movie, @movie2, @movie3])
      post :same_director, { :id => @movie.id }
      assert assigns[:movies].find_all{ |elem| elem.director == 'John Doe'}.count == 3, "Movie list for known director not equal to expected count"
      response.should render_template('same_director')
    end

    it 'should provide empty movies list for unknown director' do
      @movie_empty_director = mock_model(Movie, :id => "4", :title => 'Movie No Director', :director => nil)
      Movie.stub(:find).with(@movie_empty_director.id).and_return(@movie_empty_director)
      Movie.stub(:find_with_same_director).with(nil).and_return([])
      post :same_director, { :id => @movie_empty_director.id}
      assert assigns[:movies] == [], "Movie list for unknown director is not empty"
      response.should redirect_to(movies_path)
    end
  end
end
