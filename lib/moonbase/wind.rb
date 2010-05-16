module Moonbase
  class Wind
    attr_reader :direction, :force

    def initialize(opts = {})
      @direction = (opts[:direction] || 0.0).to_f
      @force = (opts[:force] || 0.0).to_f
    end
  end
end
