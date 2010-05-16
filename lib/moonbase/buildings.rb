module Moonbase
  class Building
    def initialize(opts = {})
      @x = opts[:x] || 0.0
      @y = opts[:y] || 0.0
    end
  end

  class Hub < Building
  end
end
