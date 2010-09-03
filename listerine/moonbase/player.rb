module Moonbase
  class Player
    START_ENERGY = 11
    BASE_ENERGY_PER_TURN = 7

    attr_reader :name, :energy, :color, :selected_building, :order

    def initialize(opts = {})
      @name = opts[:name] || 'Player'
      @color = opts[:color] || [255, 0, 255]
      @energy = START_ENERGY
      @order = nil
      @selected_building = nil
    end

    def increase_energy
      @energy += energy_per_turn
    end

    def request_order
      sleep 1
      @order = []
      emit(:order)
    end

    def clear_order
      @order = nil
    end

    def energy_per_turn
      BASE_ENERGY_PER_TURN + extra_energy_per_turn
    end

    def extra_energy_per_turn
      0 # buildings.find_all(&:collector?) ...
    end
  end
end
