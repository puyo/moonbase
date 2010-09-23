require 'moonbase/events'
require 'rubygame'

module Moonbase
  class BombView
    include Rubygame
    include Sprites::Sprite

    def initialize(projectile, map_view)
      super()
      @projectile = projectile
      @map_view = map_view
      @image = Surface.new([32, 32], 0)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha
      @image.draw_circle_s([16, 16], 8, @projectile.owner.color.map{|c| c/2 })
      @image.draw_circle([16, 16], 8, [255, 255, 255])
      @rect = @image.make_rect
      update_rect
    end

    def update(milliseconds)
      update_rect
    end

    private

    def update_rect
      value = @map_view.draw_position([@projectile.position.x, @projectile.position.y, @projectile.position.h])
      value[0] -= @image.width/2
      value[1] -= @image.height/2
      @rect.topleft = value
    end
  end
end
