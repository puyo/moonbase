module Moonbase
  class Projectile
    attr_reader :position, :velocity

    def initialize(opts = {})
      @position = opts[:position] || raise('Must specify projectile position')
      @velocity = opts[:velocity] || raise('Must specify projectile velocity')
    end

    def tick(game)
      # move projectile, taking into account wind, velocity and obstacles
      # physics engine?
    end
  end

  class Bomb < Projectile
    @energy_cost = 1
  end
end
