require 'gosu'
require 'moonbase/moonbase'

module Moonbase
  class Window < Gosu::Window
    attr_accessor :game, :viewport

    def initialize
      super(800, 600, false)
      self.caption = 'Moonbase'
      self.game = Game.new(:window => self)
      self.viewport = Viewport.new(:window => self)
      viewport.x = width/2
      #viewport.y = height/2
    end

    private

    def power=(value)
      game.power = value
    end

    def update
      game.update
      viewport.update
    end

    def draw
      draw_game(game)
      draw_meter(game)
    end

    def needs_cursor?
      true
    end

    def button_down(id)
      case id
      when Gosu::KbUp then viewport.dy -= Config.keyboard.speed.scroll
      when Gosu::KbDown then viewport.dy += Config.keyboard.speed.scroll
      when Gosu::KbLeft then viewport.dx -= Config.keyboard.speed.scroll
      when Gosu::KbRight then viewport.dx += Config.keyboard.speed.scroll
      when Gosu::KbSpace then self.power = 0; game.power_delta = 4
      when kb_comma then game.angle_delta -= Config.keyboard.speed.rotate
      when kb_period then game.angle_delta += Config.keyboard.speed.rotate
      end
    end

    def button_up(id)
      return close if id == Gosu::KbEscape
      case id
      when Gosu::KbUp then viewport.dy += Config.keyboard.speed.scroll
      when Gosu::KbDown then viewport.dy -= Config.keyboard.speed.scroll
      when Gosu::KbLeft then viewport.dx += Config.keyboard.speed.scroll
      when Gosu::KbRight then viewport.dx -= Config.keyboard.speed.scroll
      when Gosu::KbSpace then game.record_order
      when kb_comma then game.angle_delta += Config.keyboard.speed.rotate
      when kb_period then game.angle_delta -= Config.keyboard.speed.rotate
      end
    end

    def kb_comma
      @kb_comma ||= char_to_button_id(',')
    end

    def kb_period
      @kb_period ||= char_to_button_id('.')
    end

    def draw_game(game)
      viewport.translate_draw do
        draw_map(game.map)
        game.hubs.each{|hub| draw_hub(hub) }
        game.bombs.each{|bomb| draw_bomb(bomb) }
      end
    end

    def draw_hub(hub)
      x, y = viewport.surface_to_viewport_coordinates([hub.position.x, hub.position.y, hub.position.h])
      hub_image.draw(
        x - hub_image.width/2,
        y - hub_image.height/2,
        10, 1, 1, Moonbase.rgba(*(hub.owner.color + [0xff])),
      )
      #return unless selected
      scale(1, 0.5, x, y) do
        rotate(hub.angle + 180, x, y) do
          node_selection_image.draw(
            x - node_selection_image.width/2,
            y - node_selection_image.height/2,
            9, 1, 1, 0xff00ff00,
          )
        end
      end
    end

    def draw_map(map)
      w = map.width
      h = map.height
      g = map.tile_size
      gh = map.tile_size/2
      sx = sy = 0
      translate(-w*g, 0) do
        draw_quad(
          sx + w*g  , sy       , map_color[0], # top
          sx        , sy + h*gh, map_color[1], # left
          sx + w*g  , sy + h*g , map_color[2], # bottom
          sx + 2*w*g, sy + h*gh, map_color[3],  # right
        )
      end
    end

    def draw_meter(game)
      w = 20
      h = game.power
      c = 0xff00ff00
      draw_quad(
        0, 0, c,
        w, 0, c,
        w, h, c,
        0, h, c,
      )
    end

    def draw_bomb(bomb)
      draw_bomb_image(bomb)
      draw_bomb_shadow(bomb)
    end

    def draw_bomb_image(bomb)
      x, y = viewport.surface_to_viewport_coordinates([bomb.position.x, bomb.position.y, bomb.position.h])
      bomb_image.draw(x - bomb_image.width, y - bomb_image.height, 30)
    end

    def draw_bomb_shadow(bomb)
      ground = game.map.height_at([bomb.position.x, bomb.position.y])
      above = bomb.position.h - ground
      scale = [[(Projectile::MAX_HEIGHT - above)/Projectile::MAX_HEIGHT, 1.0].min, 0.5].max
      x, y = viewport.surface_to_viewport_coordinates([bomb.position.x, bomb.position.y, ground])
      scale(scale, scale/2, x, y) do
        bomb_image.draw(x - bomb_image.width, y - bomb_image.height, 29, 1, 1, 0x80888888)
      end
    end

    def map_color
      @map_color ||= [
        Moonbase.rgba(255, 255, 0, 255),
        Moonbase.rgba(0, 255, 255, 255),
        Moonbase.rgba(0, 0, 255, 255),
        Moonbase.rgba(255, 0, 0, 255),
      ]
    end

    def bomb_image
      @bomb_image ||= Moonbase.image(self, 'data/bomb.png')
    end

    def hub_image
      @hub_image ||= Moonbase.image(self, 'data/hub_gosu.png')
    end

    def node_selection_image
      @node_selection_image ||= Moonbase.image(self, 'data/selection_gosu.png')
    end
  end
end
