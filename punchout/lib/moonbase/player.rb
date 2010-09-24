require 'moonbase/order'

module Moonbase
  class Player

    START_ENERGY = 11
    BASE_ENERGY_PER_TURN = 7

    attr_reader :name, :energy, :color, :selected_building, :hubs, :bombs
    attr_accessor :id, :order

    def initialize(opts)
      @name = opts[:name] || raise('Must specify name for a player')
      @color = opts[:color] || [255, 0, 255]
      @energy = START_ENERGY
      @selected_building = nil
      @hubs = []
      @bombs = []
      @id = nil
      @order = nil
    end

    def select_building(building)
      @selected_building = building
    end

    def request_order(game)
      @order = random_order
    end

    def random_order
      randx = rand(20) - 10
      randy = rand(20) - 10
      bomb = Bomb.new(:position => @hubs.first.position.dup, :velocity => Vector3D.new(randx, randy, 20), :owner => self)
      ShootOrder.new(:from => Vector3D.origin, :projectile => bomb, :direction => 0, :power => 10)
    end

    def on_turn_start(game)
      @energy += energy_per_turn(game)
    end

    def energy_per_turn(game)
      BASE_ENERGY_PER_TURN + extra_energy_per_turn(game)
    end

    def extra_energy_per_turn(game)
      0 # game.find_buildings(:owned_by => self, :type => Collector)...
    end

    def on_building_added(building)
      if building.is_a?(Hub) and @selected_building.nil?
        @selected_building = building
      end
    end

    def to_s
      "<#Player #{@id}>"
    end
  end
end
