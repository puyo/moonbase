module Moonbase
  class Viewport
    attr_accessor :scroll_x, :scroll_y

    def initialize(tile_size = 32)
      @scroll_x = 0
      @scroll_y = 0
    end

    def viewport_to_surface_coordinate(coord)
      vx, vy = coord
      vx -= @scroll_x
      vy -= @scroll_y
      h = 0
      sx = vx/2 + vy - h
      sy = -vx/2 + vy - h
      [sx, sy]
    end

    def surface_to_viewport_coordinates(coord)
      sx, sy = coord
      h = 0
      vx = sx - sy
      vy = (sx + sy)/2 + h
      [@scroll_x + vx, @scroll_y + vy]
    end
  end
end
