require 'moonbase/building'

module Moonbase
  class Hub < Building
    attr_accessor :selected

    def collision?(coords)
      # d = sqrt(dx*dx + dy*dy + dh*dh)
      # d2 = dx*dx + dy*dy + dh*dh
      dx = coords[0] - @position.x
      dy = coords[1] - @position.y
      dh = coords[2] - @position.h
      d2 = dx*dx + dy*dy + dh*dh
      p d2
    end
  end
end
