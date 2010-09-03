module Moonbase
  class HubList
    def initialize
      @hubs = []
    end

    def add(hub)
      @hubs.push(hub)
    end
  end
end
