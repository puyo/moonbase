module Moonbase
  class Building
    attr_reader :position, :owner

    def initialize(opts = {})
      @position = opts[:position] || raise(ArgumentError, 'position required')
      @owner = opts[:owner] || raise(ArgumentError, 'owner required')
    end
  end

  class Hub < Building
  end
end
