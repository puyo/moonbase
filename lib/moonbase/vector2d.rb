
module Moo
  class Vector2D
    attr_accessor :x, :y

    def initialize(x, y)
      @x, @y = x.to_f, y.to_f
    end
  end
end

def pos(*args)
  Moo::Vector2D.new(*args)
end
