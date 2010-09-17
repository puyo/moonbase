require 'moonbase/viewport'

include Moonbase

describe Viewport do
  before(:each) do
    @viewport = Viewport.new
  end

  [
    {:viewport => [0.0, 0.0], :surface => [0.0, 0.0]},
    {:viewport => [0.0, 5.0], :surface => [5.0, 5.0]},
    {:viewport => [10.0, 0.0], :surface => [5.0, -5.0]},
    {:viewport => [5.0, 7.5], :surface => [10.0, 5.0]},
  ].each do |values|
    it "should map viewport #{values[:viewport].inspect} to surface #{values[:surface].inspect}" do
      @viewport.viewport_to_surface_coordinate(values[:viewport]).should == values[:surface]
    end
    it "should map surface #{values[:surface].inspect} to viewport #{values[:viewport].inspect}" do
      @viewport.surface_to_viewport_coordinates(values[:surface]).should == values[:viewport]
    end
  end
end
