module Moonbase
  class PlayerList
    def initialize
      @players = []
    end

    def add(player)
      @players.push(player)
    end

    def all_orders_in?
      @players.all?{|p| not p.order.nil? }
    end

    def start_turn
      @players.each(&:increase_energy)
    end

    def request_orders
      @players.each(&:request_orders)
    end
  end
end
