module Moonbase
  class Projectile
    attr_accessor :position, :velocity, :owner, :game

    MAX_HEIGHT = 100.0
    MIN_HEIGHT = 0.0

    def initialize(opts = {})
      @position = opts[:position] || raise('Must specify projectile position')
      @velocity = opts[:velocity] || raise('Must specify projectile velocity')
      @owner = opts[:owner] || raise('Must specify projectile owner')
      @position = @position.dup
      @game = opts[:game]
    end

    def update
      delta = velocity.dup.multiply_by(0.5)
      position.add(delta.x, delta.y, delta.h)
      velocity.h -= Config.physics.gravity
    end
  end
end
