require 'rubygame'

module Moonbase
  class MeterView
    include Rubygame
    include Sprites::Sprite

    attr_accessor :level

    def initialize()
      super()
      @image = Surface.new([20, 100], 0)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha
      @level = 0
      @rect = @image.make_rect
      redraw
      update_rect
    end

    def update(milliseconds)
      redraw
    end

    def redraw
      @image.fill([0, 0, 0])
      @image.draw_box_s([0, 100 - @level], @image.size, [0, 255, 0])
      @image.draw_box([0, 0], [@image.width - 1, @image.height - 1], [255, 255, 255])
    end

    private

    def update_rect
      @rect.topleft = [20, 20]
    end
  end
end
