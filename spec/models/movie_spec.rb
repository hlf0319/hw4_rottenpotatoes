require 'spec_helper'

describe Movie do
  describe 'check ratings' do
    # first spec elided for brevity
    it 'should list all ratings' do
      Movie.all_ratings
    end
  end
end