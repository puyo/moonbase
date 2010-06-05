require 'moonbase/events'

module Moonbase 
  class MapView
    include EventHandler::HasEventHandler
    include Sprites::Sprite

    attr_accessor :vx, :vy

    def initialize(map)
      super()
      @vx, @vy = 0, 0
      @scroll_x = -500
      @scroll_y = -500
      @tile_size = 32
      @map = map

      width = 50 #@map.width
      height = 50 #@map.height
      g = @tile_size
      gh = g/2

      pix_w = (width + height)*g
      pix_h = (width + height)*gh
      @image = Surface.new([pix_w, pix_h], 0, Surface::HWSURFACE)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha

      (0...width).each do |i|
        (0...height).each do |j|
          px = i.to_f / width
          py = j.to_f / height
          sx = (i + j) * g
          sy = (height - 1 + i - j) * gh

          # iso tile outline
          points = [
            [sx + g  , sy     ], # top
            [sx      , sy + gh], # left
            [sx + g  , sy + g ], # bottom
            [sx + 2*g, sy + gh], # right
          ]
          @image.draw_polygon_s(points, [px*255, 255, py*255])
          @image.draw_polygon(points, [255, 255, 255])
        end
      end

      update_rect
    end

    def update(event)
      @scroll_x -= 500*event.seconds*@vx
      @scroll_y -= 500*event.seconds*@vy
      update_rect
    end

    def update_rect
      @rect = Rect.new(@scroll_x, @scroll_y, *@image.size)
    end
  end
end
