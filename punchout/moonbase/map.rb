module Moonbase
  class Map
    attr_accessor :width, :height, :window, :game, :tile_size

    def initialize(opts = {})
      @width, @height, @window, @game = opts.values_at(:width, :height, :window, :game)
      @width ||= 100
      @height ||= 100
      @tile_size = opts[:tile_size] || 16
    end

    def height_at(xy)
      0 # flat, for now
    end
  end
end
