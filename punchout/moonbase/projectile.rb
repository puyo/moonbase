module Moonbase
  class Projectile
    attr_accessor :position, :velocity, :owner, :game

    MAX_HEIGHT = 100.0
    MIN_HEIGHT = 0.0

    def initialize(opts = {})
      @position = opts[:position] || raise('Must specify projectile position')
      @velocity = opts[:velocity] || raise('Must specify projectile velocity')
      @owner = opts[:owner] || raise('Must specify projectile owner')
      @position = @position.dup
      @game = opts[:game]
    end

    def image
      @image ||= Gosu::Image.new(game.window, 'data/bomb.png')
    end

    def update
      delta = velocity.dup.multiply_by(0.5)
      position.add(delta.x, delta.y, delta.h)
      velocity.h -= Config.physics.gravity
    end

    def draw
      draw_bomb
      draw_shadow(image)
    end

    def draw_bomb
      x, y = game.viewport.surface_to_viewport_coordinates([position.x, position.y, position.h])
      image.draw(x - image.width, y - image.height, 30)
    end

    def draw_shadow(image)
      ground = game.map.height_at([position.x, position.y])
      above = position.h - ground
      scale = [[(MAX_HEIGHT - above)/MAX_HEIGHT, 1.0].min, 0.5].max
      x, y = game.viewport.surface_to_viewport_coordinates([position.x, position.y, ground])
      game.window.scale(scale, scale/2, x, y) do
        image.draw(x - image.width, y - image.height, 29, 1, 1, 0x80888888)
      end
    end
  end
end
