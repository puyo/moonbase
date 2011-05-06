require 'rubygems' rescue nil
require 'gosu'

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'moonbase/game'

module Moonbase
  class Window < Gosu::Window
    def initialize
      super(640, 480, false)
      self.caption = 'Moonbase'
      @game = Game.new(:window => self)
    end

    def update
      @game.update
    end

    def draw
      @game.draw
    end

    def button_down(id)
      @game.button_down(id)
    end

    def button_up(id)
      return close if id == Gosu::KbEscape
      @game.button_up(id)
    end
  end
end

if $0 == __FILE__
  Moonbase::Window.new.show
end
