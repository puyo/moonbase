module Moonbase
  class Order
  end

  class SkipOrder < Order
    def process(game, player)
      # don't need to do anything! :-)
    end
  end

  class ShootOrder < Order
    attr_reader :direction, :projectile, :power

    def initialize(opts = {})
      @projectile = opts[:projectile] || raise('Must specify projectile object to shoot')
    end

    def process(game, player)
      game.add_bomb(@projectile)
    end
  end

  class QuitOrder < Order
    def process(game, player)
      game.remove_player(player)
    end
  end
end
