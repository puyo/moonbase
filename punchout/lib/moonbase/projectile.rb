module Moonbase
  class Projectile
    attr_reader :position, :velocity, :owner

    def initialize(opts = {})
      @position = opts[:position] || raise('Must specify projectile position')
      @velocity = opts[:velocity] || raise('Must specify projectile velocity')
      @owner = opts[:owner] || raise('Must specify projectile owner')
    end

    def on_tick(milliseconds)
      @position += @velocity * (milliseconds / 50.0)
      @velocity.h -= milliseconds / 50.0
    end
  end
end
