require 'moonbase/building'

module Moonbase
  class Hub < Building
    attr_accessor :selected

    def collision?(coords)
      dsquared(coords) < 350.0
    end

    private

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
