module Moonbase
  class Building
    attr_reader :position

    def initialize(opts = {})
      @position = opts[:position] || raise('Must specify building position')
    end
  end

  class Hub < Building
  end
end
