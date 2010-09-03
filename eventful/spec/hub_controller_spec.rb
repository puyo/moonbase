require 'moonbase/hub_controller'
require 'moonbase/emitter'

include Moonbase

describe HubController do
  include HubController
  include Emitter

  context 'on a turn event' do
    before(:each) do
      @hub = mock('hub')
      add_hub(@hub)
    end
  end
end
