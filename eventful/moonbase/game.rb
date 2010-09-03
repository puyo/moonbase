require 'moonbase/emitter'
require 'moonbase/player_controller'

module Moonbase
  class Game
    include Emitter
    include PlayerController
    include BombController

    attr_reader :phase

    def initialize()
      @phase = :create
      @turn_number = 0

      on(:all_orders_in) do
        set_phase(:action)
      end
    end

    def start
      emit(:start)
      emit(:turn, @turn_number += 1)
      set_phase(:orders)
    end

    def update(dt)
      emit(:update, dt)
    end

    private

    def set_phase(phase)
      @phase = phase
      emit(phase)
    end
  end
end
