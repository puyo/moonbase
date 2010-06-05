module Moonbase
  class ProjectileView
    include EventHandler::HasEventHandler

    attr_accessor :vx, :vy

    def initialize(projectile)
      super()
      @projectile = projectile
      @image = Surface.new([32, 32], 0, Surface::HWSURFACE)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha
      @rect = @image.to_rect

      #@image.draw_circle_s(points, [px*255, 255, py*255])
    end

    def on_update(tick_event)
      @bomb.update(tick_event.seconds)
    end

    def on_draw(event)
    end
  end
end
