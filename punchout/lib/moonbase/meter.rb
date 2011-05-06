module Moonbase
  class Meter
    attr_accessor :level, :game

    def initialize(opts = {})
      @game = opts[:game]
      @level = 0
    end

    def draw
      #draw_quad (x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z=0, mode=:default)
      #@image.draw_box_s([0, 100 - @level], @image.size, [0, 255, 0])
      #@image.draw_box([0, 0], [@image.width - 1, @image.height - 1], [255, 255,
    end

    def update
    end
  end
end
