require 'logger'

module Moonbase
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(value)
    @logger = value
  end
end
