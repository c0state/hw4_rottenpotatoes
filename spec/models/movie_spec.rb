require 'spec_helper'

describe Movie do
  describe 'searching by director' do
    it 'should return empty list for unknown director' do
      Movie.stub(:find_with_same_director).with('Unknown').and_return([])
      assert Movie.find_with_same_director('Unknown') == [], "Movie list for unknown director is not empty"
    end

    it 'should return list of movies for director' do
      mm = mock(Movie)
      Movie.stub(:find_with_same_director).with('Known').and_return([mm])
      assert Movie.find_with_same_director('Known') == [mm], "Movie list for known director is not correct"
    end
  end
end
