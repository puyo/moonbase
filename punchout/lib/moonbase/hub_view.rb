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
      @image.to_display_alpha rescue nil
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
      if @hub.selected
        if @t > 500
          i = 1000 - @t
        else
          i = @t
        end
        i = i * 255 / 1000
        @image.draw_ellipse_s([20, 16], [18, 9], [i, 255, i])
      end
      @image.draw_ellipse_s([20, 16], [14, 7], [1, 1, 1, 127])
      @image.draw_ellipse_s([20, 14], [14, 7], @color)
    end

    private

    def update_rect
      @rect.topleft = @map_view.draw_position([@hub.position.x, @hub.position.y])
    end
  end
end
