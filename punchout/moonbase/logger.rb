require 'logger'

module Moonbase
  module Logger
    def logger
      @logger ||= ::Logger.new(STDOUT)
    end

    def logger=(value)
      @logger = value
    end
  end
end
