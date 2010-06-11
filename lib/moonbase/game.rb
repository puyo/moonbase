require 'moonbase/map'
require 'moonbase/order'
require 'moonbase/vector3d'

module Moonbase
  def self.hash_of_arrays
    Hash.new {|h, k| h[k] = [] }
  end

  class Game
    attr_reader :map, :players, :phase, :buildings, :projectiles

    def initialize(opts = {})
      @buildings = Moonbase.hash_of_arrays
      @projectiles = Moonbase.hash_of_arrays
      @orders = {}
      @phase = :create
      @players = []
      @map = nil
    end

    def map=(map)
      @map = map
    end

    def start
      @phase = :orders
    end

    def on_tick(milliseconds)
      if @phase == :orders
        on_tick_orders(milliseconds)
      elsif @phase == :move
        on_tick_move(milliseconds)
      end
    end

    def each_projectile(&block)
      @projectiles.values.flatten.each(&block)
    end

    def on_tick_move(milliseconds)
      each_projectile do |projectile|
        projectile.on_tick(milliseconds)
      end
      if not still_moving?
        @phase = :orders
        on_turn_start
      end
    end

    def still_moving?
      @projectiles.size > 0
    end

    def on_tick_orders(milliseconds)
      @players.each do |p| 
        order = p.request_order(self)
        set_order(p, order) if order
      end
      if not awaiting_orders?
        @phase = :move
        process_orders
      end
    end

    def process_orders
      @orders.each do |player, order|
        order.process(self, player)
      end
      @orders.clear
    end

    def awaiting_orders?
      @orders.size < @players.size
    end

    def add_player(player)
      @players.push player
    end

    def add_building(building)
      @buildings[building.owner] = building
    end

    def add_projectile(projectile)
      @projectiles[projectile.owner].push(projectile)
    end

    def destroy_projectile(projectile)
      @projectiles[projectile.owner].delete(projectile)
    end

    def set_order(player, order)
      @orders[player] = order
    end

    def remove_player(player)
      @players.delete(player)
      @orders.delete(player)
      @projectiles.delete(player)
      @buildings.delete(player)
      if @players.empty?
        @phase = :quit
      end
    end

    def on_turn_start
      #puts 'on_turn_start'
      @players.each{|p| p.on_turn_start(self) }
    end
  end
end
