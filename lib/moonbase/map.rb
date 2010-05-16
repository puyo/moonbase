require 'moonbase/player'
require 'moonbase/buildings'
require 'moonbase/wind'

module Moonbase
  class Map
    attr_reader :width, :height, :wind

    def initialize(opts = {})
      @width = opts[:width] || 100.0
      @height = opts[:height] || 100.0
      @wind = Wind.new(:direction => 0, :force => 0)
    end
  end
end
