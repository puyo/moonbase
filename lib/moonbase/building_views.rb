require 'moonbase/events'

module Moonbase 
  class BuildingView
    include EventHandler::HasEventHandler
    include Sprites::Sprite

    def initialize(building)
      super()
      @building = building
      @image = Surface.new([32, 32], 0, Surface::HWSURFACE)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha rescue nil
      @image.draw_circle_s([16, 16], 16, [255, 0, 255])
      @rect = Rect.new(@building.position.x, @building.position.y, *@image.size)
    end

    def update(event)
    end
  end
end
