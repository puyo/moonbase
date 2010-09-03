require 'spec_helper'
require 'moonbase/map'

include Moonbase

describe Map do
  before(:each) do
    @map = Map.new(:size => [20,20])
  end

  context '#height_at' do
    it 'should provide the height at a given x,y position' do
      @map.height_at([0, 0]).should == 0
    end

    it 'should wrap coordinates around' do
      @map.height_at([@map.size[0] + 1, 0]).should == 0
    end
  end
end
