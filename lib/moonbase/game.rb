require 'moonbase/map'
require 'moonbase/order'
require 'moonbase/vector3d'

module Moonbase
  class Game
    class Options
    end

    attr_reader :map, :players, :phase, :buildings, :projectiles

    def initialize(opts = {})
      @opts = opts
      @players = opts[:players] || raise('Must specify players for game')
      @buildings = Hash.new {|h, k| h[k] = [] }
      @projectiles = Hash.new {|h, k| h[k] = [] }
      @map = opts[:map] || raise('Must specify map')
      @orders = {}
      @phase = :orders
    end

    def tick
      case @phase
      when :orders then tick_orders
      when :move then tick_move
      when :quit then return false
      end
      return true
    end

    def tick_move
      #puts 'tick_move'
      if not still_moving?
        @phase = :orders
        on_turn_start
      end
    end

    def still_moving?
      @projectiles.size > 0
    end

    def tick_orders
      #puts 'tick_orders'
      @players.each do |p| 
        if order = p.request_order(self)
          set_order(p, order)
        end
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

    def add_building(player, building)
      @buildings[player].push(building)
    end

    def add_projectile(player, projectile)
      @projectiles[player].push(projectile)
    end

    def set_order(player, order)
      @orders[player] = order
    end

    def remove_player(player)
      @players.delete(player)
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
