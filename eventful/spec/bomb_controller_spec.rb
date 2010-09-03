require 'moonbase/bomb_controller'
require 'moonbase/emitter'

include Moonbase

describe BombController do
  include BombController
  include Emitter

  context 'on an update event' do
    before(:each) do
      @bomb = mock('bomb')
      @bomb.extend(Emitter)
      add_bomb(@bomb)
    end

    after(:each) do
      emit(:update, 1)
    end

    it "should move the bomb" do
      @bomb.should_receive(:update).with(1)
    end
  end
end
