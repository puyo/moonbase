require 'moonbase/building'

module Moonbase
  class Hub < Building
    attr_accessor :selected, :angle

    def initialize(opts = {})
      super(opts)
      @selected = true
      @angle = 0.0
    end

    def draw
      x, y = game.viewport.surface_to_viewport_coordinates([@position.x, @position.y, @position.h])
      image.draw(x - image.width/2,
                 y - image.height/2,
                 10, 1, 1, Moonbase.rgba(*(owner.color + [0xff])))
      #return unless selected
      game.window.scale(1, 0.5, x, y) do
        game.window.rotate(@angle + 180, x, y) do
          selection_image.draw(x - selection_image.width/2,
                               y - selection_image.height/2,
                               9, 1, 1, 0xff00ff00)
        end
      end
    end

    def update
    end

    def collision?(coords)
      dsquared(coords) < 350.0 # roughly, size squared
    end

    private

    def image
      @image ||= Moonbase.image(game.window, 'data/hub_gosu.png')
    end

    def selection_image
      @selection_image ||= Moonbase.image(game.window, 'data/selection_gosu.png')
    end

    def dsquared(coords)
      dsquared2(coords[0] - @position.x,
                coords[1] - @position.y,
                coords[2] - @position.h)
    end

    def dsquared2(dx, dy, dh)
      dx*dx + (dy*dy)*4 + dh*dh # TODO: think more about this
    end
  end
end
