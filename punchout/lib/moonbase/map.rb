module Moonbase
  class Map
    attr_reader :width, :height

    def initialize(opts = {})
      @width = opts[:width] || 100
      @height = opts[:height] || 100
    end

    def surface_coordinate(x, y)
      Vector3D.new(x, y, height(x, y))
    end

    def height(x, y)
      0 # flat, for now
    end
  end
end
