require 'moonbase/events'
require 'rubygame'

module Moonbase
  class MapView
    include Rubygame
    include Sprites::Sprite

    attr_accessor :vx, :vy
    attr_reader :map

    def initialize(map, viewport)
      super()
      @viewport = viewport
      @vx, @vy = 0, 0
      @tile_size = 32
      @g = @tile_size
      @gh = @tile_size/2
      #@scroll_x = -width*@g + 300
      #@scroll_y = height*@gh/2
      @map = map
      @position = Vector3D.origin
      create_image
      draw_iso_tiles
      update_rect
    end

    def update(ms)
      @viewport.scroll_x -= ms*@vx*0.5
      @viewport.scroll_y -= ms*@vy*0.5
      update_rect
    end

    def draw_position(xy3d)
      xy2d = @viewport.surface_to_viewport_coordinates(xy3d)
      xy2d[0] += x_image_offset
      xy2d
    end

    def surface_position(xy2d)
      @viewport.viewport_to_surface_coordinate([xy2d[0] - x_image_offset, xy2d[1]])
    end

    private

    def x_image_offset
      @image.size[0]/2 - @g
    end

    def width; 50 end
    def height; 50 end

    def create_image
      @image = Surface.new([(width + height)*@g, (width + height)*@gh], 0)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha rescue nil
      @rect = @image.make_rect
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
      [px*255, 64, py*255]
    end

    def draw_iso_tile(i, j)
      xy2d = draw_position([i*@tile_size, j*@tile_size])
      points = iso_tile_points(*xy2d)
      @image.draw_polygon_s(points, color(i, j))
      @image.draw_polygon(points, Color[:black])
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
      @rect.topleft = @viewport.surface_to_viewport_coordinates([@position.x, @position.y])
    end
  end
end
