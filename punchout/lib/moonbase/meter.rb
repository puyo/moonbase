module Moonbase
  class Meter
    attr_accessor :level

    def initialize(opts = {})
      @window = opts[:window]
      @level = 0
    end

    def draw
    end

    def update
    end
  end
end
