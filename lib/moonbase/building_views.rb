require 'moonbase/events'

module Moonbase 
  class BuildingView
    include EventHandler::HasEventHandler
    include Sprites::Sprite

    def initialize(building, map_view)
      super()
      @building = building
      @map_view = map_view
      @image = Surface.new([32, 32], 0, Surface::HWSURFACE)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha rescue nil
      @image.draw_ellipse_s([16, 16], [16, 8], @building.owner.color)
      @image.draw_ellipse([16, 16], [16, 8], [255, 255, 255])
      update_rect
    end
    
    def update(event)
      update_rect
    end

    private

    def update_rect
      @rect = @map_view.iso_rect(@building.position, @image.size)
    end
  end
end
