require 'moonbase/events'

module Moonbase 
  class BuildingView
    include EventHandler::HasEventHandler
    include Sprites::Sprite

    def initialize(building, map_view)
      super()
      @building = building
      @map_view = map_view
      @image = Surface.new([40, 32], 0, Surface::HWSURFACE)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha rescue nil
      @t = 0
      redraw
      update_rect
    end
    
    def update(event)
      @t += event.milliseconds
      while @t > 1000
        @t -= 1000
      end
      redraw
      update_rect
    end

    def redraw
      if selected?
        if @t > 500
          i = 1000 - @t
        else
          i = @t
        end
        i = i * 255 / 1000
        @image.draw_ellipse_s([20, 16], [18, 9], [i, 255, i])
      end
      @image.draw_ellipse_s([20, 16], [14, 7], [1, 1, 1, 127])
      @image.draw_ellipse_s([20, 14], [14, 7], @building.owner.color)
    end

    def selected?
      @building.owner.selected_building.object_id == @building.object_id
    end

    private

    def update_rect
      @rect = @map_view.iso_rect(@building.position, @image.size)
    end
  end
end
