module Moonbase
  module HubController
    def hubs
      @hubs ||= []
    end

    def add_hub(hub)
      hubs.push(hub)
    end
  end
end
