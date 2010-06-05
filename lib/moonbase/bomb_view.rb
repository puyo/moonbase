module Moonbase
  class BombView
    include EventHandler::HasEventHandler

    attr_accessor :vx, :vy

    def initialize(game, bomb)
      @game = game
      @bomb = bomb
      make_magic_hooks({
        Events::DrawSprites => :on_draw,
        :tick => :on_update,
      })
    end

    def on_update(tick_event)
      @bomb.update(tick_event.seconds)
    end

    def on_draw(event)
    end
  end
end
