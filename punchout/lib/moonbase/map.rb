module Moonbase
  class Map
    attr_reader :width, :height

    def initialize(opts = {})
      @width = opts[:width] || 100
      @height = opts[:height] || 100
    end

    def height_at(xy)
      0 # flat, for now
    end
  end
end
