module Moonbase
  class Projectile
    attr_reader :position, :velocity, :owner

    def initialize(opts = {})
      @position = opts[:position] || raise('Must specify projectile position')
      @velocity = opts[:velocity] || raise('Must specify projectile velocity')
      @owner = opts[:owner] || raise('Must specify projectile owner')
      @position = @position.dup
    end

    def on_tick(milliseconds)
      delta = @velocity.dup.multiply_by(milliseconds / 50.0)
      @position.add(delta.x, delta.y, delta.h)
      @velocity.h -= milliseconds / 50.0
    end
  end
end
