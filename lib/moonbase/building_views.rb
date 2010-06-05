require 'moonbase/events'

module Moonbase 
  class BuildingView
    include EventHandler::HasEventHandler
    include Sprites::Sprite

    def initialize(opts)
      super()
      @building = opts[:building]
      #@colour => opts[:player].colour

      @image = Surface.new([32, 32], 0, Surface::HWSURFACE)
      @image.colorkey = [0, 0, 0]
      @image.to_display_alpha

      @image.draw_circle(16, 16, 16, [255, 255, 255])
      @rect = Rect.new(@building.position.x, @building.position.y, *@image.size)
    end

    def update(event)
    end
  end
end
