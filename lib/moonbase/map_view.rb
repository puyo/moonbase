require 'moonbase/events'

module Moonbase 
  class MapView
    include EventHandler::HasEventHandler
    include Sprites::Sprite

    attr_accessor :vx, :vy
    attr_reader :scroll_x, :scroll_y

    def initialize(map)
      super()
      @vx, @vy = 0, 0
      @scroll_x = 0
      @scroll_y = 0
      @tile_size = 32
      @g = @tile_size
      @gh = @tile_size/2
      @map = map
      @position = Vector3D.origin
      create_image
      draw_iso_tiles
      update_rect
    end

    def update(event)
      @scroll_x -= 500*event.seconds*@vx
      @scroll_y -= 500*event.seconds*@vy
      update_rect
    end

    def iso_rect(position3d, size)
      x2d = position3d.x - position3d.y
      y2d = position3d.x + position3d.y
      Rect.new(@scroll_x + x2d - size[0]/2, @scroll_y + y2d - size[1]/2, *size)
    end

    private

    def width; 50 end
    def height; 50 end

    def create_image
      @image = Surface.new([(width + height)*@g, (width + height)*@gh], 0, Surface::HWSURFACE)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha rescue nil
    end

    def each_tile_coordinate
      (0...width).each do |i|
        (0...height).each do |j|
          yield i, j
        end
      end
    end

    def draw_iso_tiles
      each_tile_coordinate do |i, j|
        draw_iso_tile(i, j)
      end
    end

    def color(i, j)
      px = i.to_f / width
      py = j.to_f / height
      [px*255, 255, py*255]
    end

    def draw_iso_tile(i, j)
      sx = (width - 1 + i - j) * @g
      sy = (i + j) * @gh
      points = iso_tile_points(sx, sy)
      @image.draw_polygon_s(points, color(i, j))
      @image.draw_polygon(points, Color[:white])
    end

    def iso_tile_points(sx, sy)
      points = [
        [sx + @g  , sy      ], # top
        [sx       , sy + @gh], # left
        [sx + @g  , sy + @g ], # bottom
        [sx + 2*@g, sy + @gh], # right
      ]
    end

    def update_rect
      @rect = iso_rect(@position, @image.size)
    end
  end
end
