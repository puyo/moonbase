require 'rubygame'

module Moonbase
  module Events
    include Rubygame
    def self.pressed(key)
      key
    end

    def self.released(key)
      EventTriggers::KeyReleaseTrigger.new(key)
    end

    class DrawSprites
      attr_accessor :screen

      def initialize(screen)
        @screen = screen
      end
    end

    class UndrawSprites
      attr_accessor :screen, :background

      def initialize(screen, background)
        @screen, @background = screen, background
      end
    end
  end
end
