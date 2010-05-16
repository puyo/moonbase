module Moonbase
  class Order
  end

  class SkipOrder < Order
    def process(game, player)
      # don't need to do anything! :-)
    end
  end

  class ShootOrder < Order
    attr_reader :from, :projectile_class, :direction, :power

    def initialize(opts = {})
      @from = opts[:from] || raise('Must specify which building to shoot from') # building
      @direction = opts[:direction] || raise('Must specify shoot direction')
      @projectile_class = opts[:projectile_class] || raise('Must specify projectile class to shoot')
      @power = opts[:power] || raise('Must specify shoot power')
    end

    def new_projectile
      @projectile_class.new(:position => @from.position.dup,
                            :velocity => Vector3D.new(10, 10, 20))
    end

    def process(game, player)
      game.add_projectile(player, new_projectile)
    end
  end
end
