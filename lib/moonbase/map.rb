require 'moonbase/player'
require 'moonbase/buildings'

module Moonbase
  class Map
    attr_reader :width, :height

    def initialize(opts = {})
      @width = opts[:width] || 100
      @height = opts[:height] || 100
    end

    def self.coordinate_3d(xy)
      Vector3D.new(xy[0], xy[1], 0) # flat
    end
  end
end
