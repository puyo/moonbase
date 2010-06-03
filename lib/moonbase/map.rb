require 'moonbase/player'
require 'moonbase/buildings'

module Moonbase
  class Map
    attr_reader :width, :height

    def initialize(opts = {})
      @width = opts[:width] || 100
      @height = opts[:height] || 100
    end
  end
end
