module Moonbase
  class Viewport
    attr_accessor :x, :y, :dx, :dy

    def initialize(opts = nil)
      opts ||= {}
      @window = opts[:window]
      @x = @y = @dx = @dy = 0
    end

    def viewport_to_surface_coordinate(coord)
      vx, vy = coord
      h = 0
      sx = vx/2 + vy + h
      sy = -vx/2 + vy + h
      [sx, sy]
    end

    def surface_to_viewport_coordinates(coord)
      sx, sy, h = coord
      vx = sx - sy
      vy = (sx + sy)/2 - h
      [vx, vy]
    end

    def translate_draw(&block)
      @window.translate(@x, @y, &block)
    end

    def update
      @x += @dx
      @y += @dy
    end
  end
end
