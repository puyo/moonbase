module Moonbase
  class Meter
    attr_accessor :level, :game

    def initialize(opts = {})
      @game = opts[:game]
      @level = 0
    end

    def draw
      w = 20
      h = @level
      c = 0xff00ff00
      game.window.draw_quad(0, 0, c,
                            w, 0, c,
                            w, h, c,
                            0, h, c)
    end

    def update
    end
  end
end
