require 'moonbase/building'

module Moonbase
  class Hub < Building
    attr_accessor :selected

    def collision?(coords)
      dx = coords[0] - @position.x
      dy = coords[1] - @position.y
      dh = coords[2] - @position.h
      dsquared = dx*dx + (dy*dy)*4 + dh*dh # TODO: think more about this
      dsquared < 350.0
    end
  end
end
