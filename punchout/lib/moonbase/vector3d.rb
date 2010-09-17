module Moonbase
  class Vector3D
    attr_accessor :x, :y, :h

    def initialize(x, y, h)
      @x, @y, @h = x.to_f, y.to_f, h.to_f
    end

    def self.origin
      new(0.0, 0.0, 0.0)
    end

    def add(x, y, h)
      @x += x
      @y += y
      @h += h
    end

    def multiply_by(scalar)
      @x *= scalar
      @y *= scalar
      @h *= scalar
      self
    end

    def ==(other)
      @x == other.x and @y == other.y and @h == other.h
    end
  end
end
