require 'moonbase/player_list'
require 'moonbase/hub_list'
require 'moonbase/bomb_list'
require 'moonbase/logger'

module Moonbase
  class Game
    attr_reader :phase

    def initialize
      set_phase :create
      @turn_number = 0
      @players = PlayerList.new
      @hubs = HubList.new
      @bombs = BombList.new
    end

    def start
      @turn_number += 1
      @players.start_turn
      set_phase(:orders)
    end

    def add_player(player)
      @players.add(player)
    end

    def add_bomb(bomb)
      @bombs.add(bomb)
    end

    def add_hub(hub)
      @hubs.add(hub)
    end

    def check_orders
      if @players.all_orders_in?
        set_phase :action
      end
    end

    def update(dt)
      @bombs.update(dt)
    end

    private

    def set_phase(phase)
      Moonbase.logger.debug { "Entering phase #{phase}" }
      @phase = phase
    end
  end
end
