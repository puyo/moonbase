module Moonbase
  class Map
    attr_reader :size

    def initialize(opts)
      @size = opts[:size]
    end

    def height_at(xy)
      0
    end
  end
end
