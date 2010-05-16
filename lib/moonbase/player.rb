require 'moonbase/order'

module Moonbase
  class Player

    START_ENERGY = 11
    BASE_ENERGY_PER_TURN = 7

    attr_reader :name, :energy

    def initialize(opts)
      @name = opts[:name] || raise('Must specify name for a player')
      @energy = START_ENERGY
    end

    def request_order(game)
      game.set_order(self, SkipOrder.new)
    end

    def on_turn_start(game)
      @energy += BASE_ENERGY_PER_TURN + extra_energy_per_turn(game)
    end

    def extra_energy_per_turn(game)
      0 # game.find_buildings(:owned_by => self, :type => Collector)...
    end
  end
end
