require 'moonbase/events'

module Moonbase 
  class MapView
    include EventHandler::HasEventHandler
    include Sprites::Sprite

    attr_accessor :vx, :vy
    attr_reader :scroll_x, :scroll_y
    attr_reader :map

    def initialize(map)
      super()
      @vx, @vy = 0, 0
      @tile_size = 32
      @g = @tile_size
      @gh = @tile_size/2
      @scroll_x = -width*@g + 300
      @scroll_y = height*@gh/2
      @map = map
      @position = Vector3D.origin
      create_image
      draw_iso_tiles
      update_rect
    end

    def select_tile(pos)
      coords = viewport_to_surface_coordinate(*pos)
      p coords
    end

    def update(event)
      @scroll_x -= event.milliseconds*@vx*0.5
      @scroll_y -= event.milliseconds*@vy*0.5
      update_rect
    end

    def iso_rect(position3d, size)
      #x2d = position3d.x - position3d.y
      #y2d = position3d.x + position3d.y - position3d.h
      #Rect.new(@scroll_x + x2d - size[0]/2, @scroll_y + y2d - size[1]/2, *size)
      
      xy2d = surface_to_viewport_coordinates(position3d.x, position3d.y, position3d.h)
      Rect.new(@scroll_x + xy2d[0] - size[0]/2, @scroll_y + xy2d[1] - size[1]/2, *size)
    end

    def viewport_to_surface_coordinate(x2d, y2d)
      x2d -= @scroll_x
      y2d -= @scroll_y
      x = (x2d + y2d)/2
      y = (y2d - x2d)/2
      Vector3D.new(x, y, 0)
    end
    
    def surface_to_viewport_coordinates(x, y, h)
      x2d = width*@g + x - y
      y2d = (x + y - h)/2
      [x2d, y2d]
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
      [px*255, 64, py*255]
    end

    def draw_iso_tile(i, j)
      xy2d = surface_to_viewport_coordinates(i*@tile_size, j*@tile_size, 0)
      #sx = (width - 1 + i - j) * @g
      #sy = (i + j) * @gh
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
      @rect = iso_rect(@position, @image.size)
    end
  end
end
