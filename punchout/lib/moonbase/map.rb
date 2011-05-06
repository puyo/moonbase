module Moonbase
  class Map
    attr_accessor :width, :height, :window, :game

    def initialize(opts = {})
      @width, @height, @window, @game = opts.values_at(:width, :height, :window, :game)
      @width ||= 100
      @height ||= 100
    end

    def height_at(xy)
      0 # flat, for now
    end

    def draw
    end
  end
end
