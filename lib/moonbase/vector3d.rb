module Moonbase
  class Vector3D
    attr_accessor :x, :y, :h

    def initialize(x, y, h)
      @x, @y, @h = x.to_f, y.to_f, h.to_f
    end

    def self.origin
      new(0.0, 0.0, 0.0)
    end

    def +(other)
      Vector3D.new(@x + other.x, @y + other.y, @h + other.h)
    end
  end
end
