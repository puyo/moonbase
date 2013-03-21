module Moonbase
  class Map
    attr_accessor :width, :height, :window, :game

    def initialize(opts = {})
      @width, @height, @window, @game = opts.values_at(:width, :height, :window, :game)
      @width ||= 100
      @height ||= 100
      @tile_size = 32
      @g = @tile_size
      @gh = @tile_size/2
    end

    def height_at(xy)
      0 # flat, for now
    end

    def draw
      sx = sy = 0
      game.window.translate(-@width*@g, 0) do
        game.window.draw_quad(sx + @width*@g  , sy              , color[0], # top
                              sx              , sy + @height*@gh, color[1], # left
                              sx + @width*@g  , sy + @height*@g , color[2], # bottom
                              sx + 2*@width*@g, sy + @height*@gh, color[3]  # right
                            )
      end
    end

    def color
      @color ||= [
        Gosu::Color.rgba(255, 255, 0, 255),
        Gosu::Color.rgba(0, 255, 255, 255),
        Gosu::Color.rgba(0, 0, 255, 255),
        Gosu::Color.rgba(255, 0, 0, 255),
      ]
    end
  end
end
