module Moonbase
  class Viewport
    def initialize(tile_size = 32)
      @tile_size = tile_size
      @g = tile_size
      @gh = tile_size/2
    end

    def viewport_to_surface_coordinate(coord)
      vx, vy = coord
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
      [vx, vy]
    end
  end
end
