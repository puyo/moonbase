require 'moonbase/events'
require 'rubygame'

module Moonbase
  class HubView
    include Rubygame
    include Sprites::Sprite

    def initialize(hub, map_view)
      super()
      @map_view = map_view
      @image = Surface.new([40, 32], 0)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha
      @color = hub.owner.color
      @t = 0
      @hub = hub
      @rect = @image.make_rect
      redraw
      update_rect
    end

    def update(milliseconds)
      @t += milliseconds
      while @t > 1000
        @t -= 1000
      end
      redraw
      update_rect
    end

    def redraw
      redraw_selection
      redraw_hub
    end

    def redraw_selection
      if @hub.selected
        if @t > 500
          i = 1000 - @t
        else
          i = @t
        end
        i = i * 255 / 500
        @image.draw_ellipse_s([20, 16], [18, 9], [i, 255, i])
      else
        @image.fill([0, 0, 0])
      end
    end

    def redraw_hub
      @image.draw_ellipse_s([20, 16], [14, 7], [1, 1, 1])
      @image.draw_ellipse_s([20, 14], [14, 7], @color)
    end

    private

    def update_rect
      @rect.topleft = @map_view.image_position(@image, [@hub.position.x, @hub.position.y, 0])
    end
  end
end
