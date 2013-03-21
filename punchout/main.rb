$LOAD_PATH.push File.dirname(__FILE__)

require 'gosu'
require 'moonbase/game'

module Moonbase
  class Window < Gosu::Window
    def initialize
      super(800, 600, false)
      self.caption = 'Moonbase'
      @game = Game.new(:window => self)
    end

    def update
      @game.update
    end

    def draw
      @game.draw
    end

    # def button_down(id)
    #   @game.button_down(id)
    # end

    # def button_up(id)
    #   return close if id == Gosu::KbEscape
    #   @game.button_up(id)
    # end

    def needs_cursor?
      true
    end

    def button_down(id)
      case id
      when Gosu::KbUp then @game.viewport.dy -= Config.keyboard.speed.scroll
      when Gosu::KbDown then @game.viewport.dy += Config.keyboard.speed.scroll
      when Gosu::KbLeft then @game.viewport.dx -= Config.keyboard.speed.scroll
      when Gosu::KbRight then @game.viewport.dx += Config.keyboard.speed.scroll
      when Gosu::KbSpace then @game.power = 0; @game.power_delta = 4
      when kb_comma then @game.angle_delta -= Config.keyboard.speed.rotate
      when kb_period then @game.angle_delta += Config.keyboard.speed.rotate
      end
    end

    def button_up(id)
      return close if id == Gosu::KbEscape
      case id
      when Gosu::KbUp then @game.viewport.dy += Config.keyboard.speed.scroll
      when Gosu::KbDown then @game.viewport.dy -= Config.keyboard.speed.scroll
      when Gosu::KbLeft then @game.viewport.dx += Config.keyboard.speed.scroll
      when Gosu::KbRight then @game.viewport.dx -= Config.keyboard.speed.scroll
      when Gosu::KbSpace then @game.record_order
      when kb_comma then @game.angle_delta += Config.keyboard.speed.rotate
      when kb_period then @game.angle_delta -= Config.keyboard.speed.rotate
      end
    end

    def kb_comma
      @kb_comma ||= char_to_button_id(',')
    end

    def kb_period
      @kb_period ||= char_to_button_id('.')
    end

  end
end

if $0 == __FILE__
  Moonbase::Window.new.show
end
