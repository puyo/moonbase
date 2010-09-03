module Moonbase
  module PlayerController
    def players
      @players ||= []
    end

    def add_player(player)
      players.push(player)
      turn_hook = on(:turn) do
        player.increase_energy
      end
      order_hook = on(:orders) do
        player.request_order
      end
      player.on(:order) do
        emit(:all_orders_in) if all_orders_in?
      end
    end

    def all_orders_in?
      players.all?{|p| not p.order.nil? }
    end
  end
end
