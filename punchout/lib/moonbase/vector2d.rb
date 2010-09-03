module Moonbase
  class Vector2D
    attr_accessor :x, :y

    def initialize(x, y)
      @x, @y = x.to_f, y.to_f
    end
  end

  def self.v2(*args)
    Vector2D.new(*args)
  end
end

