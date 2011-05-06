module Moonbase
  class Building
    attr_accessor :position, :owner, :game

    def initialize(opts = {})
      @position = opts[:position] || raise(ArgumentError, 'position required')
      @owner = opts[:owner] || raise(ArgumentError, 'owner required')
      @width = 16
      @height = 16
      @game = opts[:game]
    end
  end
end

