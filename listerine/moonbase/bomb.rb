module Moonbase
  class Bomb
    attr_reader :position, :velocity, :owner

    def initialize(opts = {})
      @position = opts[:position] || [0.0, 0.0, 0.0]
      @velocity = opts[:velocity] || [0.0, 0.0, 0.0]
    end

    def update(dt)
      @velocity[2] -= 1.0
      @position[0] += @velocity[0]
      @position[1] += @velocity[1]
      @position[2] += @velocity[2]
    end
  end
end
