require 'moonbase/events'
require 'rubygame'

module Moonbase
  class Shadow
    include Rubygame
    include Sprites::Sprite

    MAX_HEIGHT = 400.0
    MIN_HEIGHT = 0.0

    def initialize(object, map_view)
      super()
      @object = object
      @map_view = map_view
      @image = Surface.new([32, 32], 0)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha
      @rect = @image.make_rect
      redraw
      update_rect
    end

    def redraw
      calc_height
      @image.fill([0, 0, 0])
      if is_drawn?
        @image.draw_ellipse_s([16, 16], size, [1, 1, 1])
      end
    end

    def calc_height
      @height = @object.position.h - @map_view.map.height_at([@object.position.x, @object.position.y])
    end

    def is_drawn?
      @height > MIN_HEIGHT and @height < MAX_HEIGHT
    end

    def size
      scale = (MAX_HEIGHT - @height)/MAX_HEIGHT
      [8 * scale, 4 * scale]
    end

    def update(milliseconds)
      redraw
      update_rect
    end

    private

    def update_rect
      @rect.topleft = @map_view.image_position(@image, [@object.position.x, @object.position.y, 0])
    end
  end
end

