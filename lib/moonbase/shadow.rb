require 'moonbase/events'

module Moonbase 
  class Shadow
    include EventHandler::HasEventHandler
    include Sprites::Sprite

    MAX_HEIGHT = 200.0
    MIN_HEIGHT = 0.0

    def initialize(object, map_view)
      super()
      @object = object
      @map_view = map_view
      @image = Surface.new([32, 32], 0, Surface::HWSURFACE)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha rescue nil
      redraw
      update_rect
    end

    def redraw
      @height = @object.position.h - @map_view.map.height(@object.position.x, @object.position.y)
      @image.fill([0, 0, 0])
      if is_drawn?
        @image.draw_ellipse_s([16, 16], size, [64, 64, 64])
      end
    end

    def is_drawn?
      @height > MIN_HEIGHT and @height < MAX_HEIGHT
    end

    def size
      scale = (MAX_HEIGHT - @height)/MAX_HEIGHT
      [8 * scale, 4 * scale]
    end
    
    def update(event)
      redraw
      update_rect
    end

    private

    def update_rect
      @rect = @map_view.iso_rect(@map_view.map.surface_coordinate(@object.position.x, @object.position.y), @image.size)
    end
  end
end

