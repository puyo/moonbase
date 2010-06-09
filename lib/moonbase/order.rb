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
      @from = opts[:from] || raise('Must specify coordinate to shoot from')
      @direction = opts[:direction] || raise('Must specify shoot direction')
      @projectile_class = opts[:projectile_class] || raise('Must specify projectile class to shoot')
      @power = opts[:power] || raise('Must specify shoot power')
    end

    def new_projectile(owner)
      @projectile_class.new(:position => @from.dup,
                            :velocity => Vector3D.new(10, 10, 20),
                            :owner => owner)
    end

    def process(game, player)
      game.add_projectile(new_projectile(player))
    end
  end

  class QuitOrder < Order
    def process(game, player)
      game.remove_player(player)
    end
  end
end
